const Order = require('../models/Order');
const PDFDocument = require('pdfkit');
const fs = require('fs');
const path = require('path');

exports.createOrder = async (req, res) => {
    const { products, total } = req.body;

    const order = new Order({
        user: req.user._id,
        products,
        total
    });

    await order.save();
    res.status(201).json(order);
};

exports.generateInvoice = async (req, res) => {
  try {
    const orderId = req.params.id;
    const order = await Order.findById(orderId).populate('products.product').populate('user');
    if (!order) {
      return res.status(404).send('Commande non trouvée');
    }

    const doc = new PDFDocument();
    const fileName = 'invoice.pdf';

    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename=' + fileName);

    doc.pipe(res);

    doc.fontSize(20).text('Facture', { align: 'center' });

    doc.moveDown();
    doc.fontSize(12).text(`Date : ${new Date(order.createdAt).toLocaleDateString()}`);
    doc.text(`Commande ID : ${order._id}`);
    doc.text(`Client full name: ${order.user.name}`);
    doc.moveDown();

    doc.text('Produits :');

    for (const [index, item] of order.products.entries()) {
      const product = item.product; 
      const quantity = item.quantity || 1;

      if (!product) {
        doc.text(`${index + 1}. Produit introuvable`);
        continue;
      }
    const priceText = `${(product.price * quantity).toFixed(2)} DH`;
    const fullText = `${index + 1}. ${product.name} x${quantity} `;
    doc.text(fullText, { continued: true });
    doc.text(priceText, { align: 'right' });
    }

    doc.moveDown();
    doc.text(`Total : ${order.total.toFixed(2)} DH`, { align: 'right' });

    doc.end();
  } catch (err) {
    console.error("Erreur génération facture :", err);
    if (!res.headersSent) {
      res.status(500).send('Erreur génération facture');
    }
  }
};

exports.getAllOrders = async (req,res)=>{
      const orders = await Order.find().populate('products.product').populate('user');
      res.status(200).json(orders);
}



