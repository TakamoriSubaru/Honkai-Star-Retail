require('dotenv').config();
const express = require('express');
const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

// 1. KONEKSI DATABASE
const db = mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

db.connect((err) => {
    if (err) {
        console.error('Database connection failed: ' + err.stack);
        return;
    }
    console.log('Connected to MySQL Database: ' + process.env.DB_NAME);
});

// 2. MIDDLEWARE VERIFIKASI BEARER TOKEN
const verifyToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    if (!authHeader) {
        return res.status(403).json({ message: 'No token provided. Access denied.' });
    }

    const token = authHeader.split(' ')[1]; // Mengambil token dari format "Bearer <token>"
    if (!token) {
        return res.status(403).json({ message: 'Malformed token.' });
    }

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) {
            return res.status(401).json({ message: 'Failed to authenticate token.' });
        }
        req.user = decoded; // Menyimpan data user yang login ke dalam object request
        next();
    });
};

// ==========================================
// 3. ROUTE AUTENTIKASI (AUTH ROUTES)
// ==========================================

// Register User Baru
app.post('/api/auth/register', async (req, res) => {
    const { name, email, password, role } = req.body;
    if (!name || !email || !password) {
        return res.status(400).json({ message: 'All fields are required.' });
    }

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const userRole = role || 'user'; // default ke 'user' jika tidak diisi

        const query = 'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)';
        db.query(query, [name, email, hashedPassword, userRole], (err, result) => {
            if (err) {
                if (err.code === 'ER_DUP_ENTRY') {
                    return res.status(400).json({ message: 'Email already exists.' });
                }
                return res.status(500).json({ error: err.message });
            }
            res.status(201).json({ message: 'User registered successfully!', userId: result.insertId });
        });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Login Tradisional (Database)
app.post('/api/auth/login', (req, res) => {
    const { email, password } = req.body;

    const query = 'SELECT * FROM users WHERE email = ?';
    db.query(query, [email], async (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(404).json({ message: 'User not found.' });

        const user = results[0];
        const passwordIsValid = await bcrypt.compare(password, user.password);
        if (!passwordIsValid) return res.status(401).json({ message: 'Invalid password.' });

        // Generate Bearer Token Alfanumerik panjang (> 20 karakter)
        const token = jwt.sign(
            { id: user.id, name: user.name, role: user.role },
            process.env.JWT_SECRET,
            { expiresIn: '24h' }
        );

        res.status(200).json({
            message: 'Login successful!',
            token: token,
            user: { id: user.id, name: user.name, role: user.role }
        });
    });
});

// Login Menggunakan External OAuth (Simulasi Google OAuth)
app.post('/api/auth/oauth', (req, res) => {
    const { email, name, providerId } = req.body; // Data dari SDK Flutter (Google Sign-In)

    if (!email || !name) {
        return res.status(400).json({ message: 'OAuth data incomplete.' });
    }

    // Cek apakah email OAuth sudah terdaftar
    const checkQuery = 'SELECT * FROM users WHERE email = ?';
    db.query(checkQuery, [email], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });

        if (results.length > 0) {
            // Jika user sudah ada, langsung buat token
            const user = results[0];
            const token = jwt.sign(
                { id: user.id, name: user.name, role: user.role },
                process.env.JWT_SECRET,
                { expiresIn: '24h' }
            );
            return res.status(200).json({ message: 'OAuth Login successful!', token, user });
        } else {
            // Jika user belum terdaftar, buat akun otomatis berbasis OAuth (Default role: user)
            const insertQuery = 'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)';
            // Password kosong/random karena login divalidasi oleh provider external (Google)
            const dummyPassword = bcrypt.hashSync(Math.random().toString(36), 10);

            db.query(insertQuery, [name, email, dummyPassword, 'user'], (err, result) => {
                if (err) return res.status(500).json({ error: err.message });

                const token = jwt.sign(
                    { id: result.insertId, name: name, role: 'user' },
                    process.env.JWT_SECRET,
                    { expiresIn: '24h' }
                );

                res.status(201).json({
                    message: 'OAuth Account created and logged in!',
                    token,
                    user: { id: result.insertId, name, role: 'user' }
                });
            });
        }
    });
});


// ==========================================
// 4. RESOURCE CRUD ROUTES (BISA AKSES JIKA LOGIN)
// ==========================================

// GET 1: Mengambil semua resources (Akses: Admin & User)
app.get('/api/resources', verifyToken, (req, res) => {
    db.query('SELECT * FROM resources', (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(200).json(results);
    });
});

// GET 2: Mengambil satu resource detail berdasarkan ID (Akses: Admin & User)
app.get('/api/resources/:id', verifyToken, (req, res) => {
    db.query('SELECT * FROM resources WHERE id = ?', [req.params.id], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.length === 0) return res.status(404).json({ message: 'Resource not found.' });
        res.status(200).json(result[0]);
    });
});

// POST: Menambah Resource Baru (Akses: Hanya Admin)
app.post('/api/resources', verifyToken, (req, res) => {
    if (req.user.role !== 'admin') {
        return res.status(403).json({ message: 'Unauthorized. Admin role required.' });
    }

    const { name, type, description, stock, image, price } = req.body;
    const query = 'INSERT INTO resources (name, type, description, stock, image, price) VALUES (?, ?, ?, ?, ?, ?)';

    db.query(query, [name, type, description, stock, image, price], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        res.status(201).json({ message: 'Resource created successfully!', resourceId: result.insertId });
    });
});

// PUT: Mengubah/Update Data Resource (Akses: Hanya Admin)
app.put('/api/resources/:id', verifyToken, (req, res) => {
    if (req.user.role !== 'admin') {
        return res.status(403).json({ message: 'Unauthorized. Admin role required.' });
    }

    const { name, type, description, stock, image, price } = req.body;
    const query = 'UPDATE resources SET name = ?, type = ?, description = ?, stock = ?, image = ?, price = ? WHERE id = ?';

    db.query(query, [name, type, description, stock, image, price, req.params.id], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.affectedRows === 0) return res.status(404).json({ message: 'Resource not found.' });
        res.status(200).json({ message: 'Resource updated successfully!' });
    });
});

// DELETE: Menghapus Resource (Akses: Hanya Admin)
app.delete('/api/resources/:id', verifyToken, (req, res) => {
    if (req.user.role !== 'admin') {
        return res.status(403).json({ message: 'Unauthorized. Admin role required.' });
    }

    db.query('DELETE FROM resources WHERE id = ?', [req.params.id], (err, result) => {
        if (err) return res.status(500).json({ error: err.message });
        if (result.affectedRows === 0) return res.status(404).json({ message: 'Resource not found.' });
        res.status(200).json({ message: 'Resource deleted successfully!' });
    });
});


// ==========================================
// 5. TRANSACTION ROUTE (USER TRANSACTION)
// ==========================================

// POST: User membeli resource (Akses: Admin & User)
app.post('/api/transactions', verifyToken, (req, res) => {
    const { resource_id, quantity } = req.body;
    const user_id = req.user.id; // Mengambil user ID langsung dari Token Bearer

    if (!resource_id || !quantity || quantity <= 0) {
        return res.status(400).json({ message: 'Invalid resource ID or quantity.' });
    }

    // Cek ketersediaan stok & harga resource terlebih dahulu
    db.query('SELECT * FROM resources WHERE id = ?', [resource_id], (err, results) => {
        if (err) return res.status(500).json({ error: err.message });
        if (results.length === 0) return res.status(404).json({ message: 'Resource not found.' });

        const resource = results[0];

        // Validasi stok kecukupan
        if (resource.stock < quantity) {
            return res.status(400).json({ message: `Insufficient stock. Only ${resource.stock} available.` });
        }

        const total_price = resource.price * quantity;

        // Mulai SQL Transaction untuk menjaga integritas data (Atomicity)
        db.beginTransaction((transactionErr) => {
            if (transactionErr) return res.status(500).json({ error: transactionErr.message });

            // 1. Catat Data ke tabel transaksi
            const insertTxQuery = 'INSERT INTO transactions (user_id, resource_id, quantity, total_price) VALUES (?, ?, ?, ?)';
            db.query(insertTxQuery, [user_id, resource_id, quantity, total_price], (txErr, txResult) => {
                if (txErr) {
                    return db.rollback(() => res.status(500).json({ error: txErr.message }));
                }

                // 2. Kurangi stok di tabel resources
                const updateStockQuery = 'UPDATE resources SET stock = stock - ? WHERE id = ?';
                db.query(updateStockQuery, [quantity, resource_id], (stockErr, stockResult) => {
                    if (stockErr) {
                        return db.rollback(() => res.status(500).json({ error: stockErr.message }));
                    }

                    // Commit jika kedua query berhasil
                    db.commit((commitErr) => {
                        if (commitErr) {
                            return db.rollback(() => res.status(500).json({ error: commitErr.message }));
                        }
                        res.status(201).json({
                            message: 'Purchase completed successfully!',
                            transactionId: txResult.insertId,
                            total_price: total_price,
                            remaining_stock: resource.stock - quantity
                        });
                    });
                });
            });
        });
    });
});


// JALANKAN SERVER
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});