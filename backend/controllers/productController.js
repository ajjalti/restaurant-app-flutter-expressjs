const multer = require('multer');
const path = require('path');
const Product = require('../models/Product');

const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/');
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({ storage: storage });

exports.addProduct = [
    upload.single('image'),
    async (req, res) => {
        const { name, price, description } = req.body;
        let imageUrl = '';
        if (req.file) {
            imageUrl = '/uploads/' + req.file.filename;
        }

        const product = new Product({ 
            name, 
            price, 
            description, 
            imageUrl 
        });

        await product.save();
        res.status(201).json(product);
    }
];

exports.getAllProducts = async (req, res) => {
    const products = await Product.find();
    res.json(products);
};

exports.deleteById = async (req,res)=>{
    await Product.findByIdAndDelete(req.params.id);
    res.status(200);
}
