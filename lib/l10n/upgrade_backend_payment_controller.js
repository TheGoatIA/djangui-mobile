const fs = require('fs');
const filePath = 'd:/Projets/NodeJS/djangui-api/src/controllers/paymentController.ts';
let code = fs.readFileSync(filePath, 'utf8');

code = code.replace(
  /const \{ amount, type, phone \} = req\.body;\s*const result = await PaymentService\.initializeNotchPay\(req\.user\._id, amount, type, phone\);/,
  `const { amount, type, phone, plan } = req.body;
      const result = await PaymentService.initializeNotchPay(req.user._id, amount, type, phone, plan);`
);

code = code.replace(
  /const \{ amount, type \} = req\.body;\s*const result = await PaymentService\.createStripeSession\(req\.user\._id, amount, type\);/,
  `const { amount, type, plan } = req.body;
      const result = await PaymentService.createStripeSession(req.user._id, amount, type, plan);`
);

code = code.replace(
  /const result = await PaymentService\.paySubscriptionWithWallet\(req\.user\._id\);/,
  `const { plan } = req.body || {};
      const result = await PaymentService.paySubscriptionWithWallet(req.user._id, plan || 'premium');`
);

fs.writeFileSync(filePath, code, 'utf8');
console.log('paymentController.ts successfully updated with plan support.');
