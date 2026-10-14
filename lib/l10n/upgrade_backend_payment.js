const fs = require('fs');
const filePath = 'd:/Projets/NodeJS/djangui-api/src/services/paymentService.ts';
let code = fs.readFileSync(filePath, 'utf8');

// 1. Update completePayment to use payment.metadata.plan or check payment.amount / plan
code = code.replace(
  /const targetPlan = \(payment\.metadata && payment\.metadata\.plan\) \? payment\.metadata\.plan : 'premium';/g,
  ''
);

code = code.replace(
  /logger\.info\(`Upgrading user \${payment\.userId} to Premium\.\.\.`\);[\s\S]*?'subscription\.plan': 'premium',/g,
  `const targetPlan = (payment.metadata && payment.metadata.plan) || (payment.amount >= 4000 ? 'business' : 'premium');
          logger.info(\`Upgrading user \${payment.userId} to \${targetPlan}...\`);

          await User.findByIdAndUpdate(
            payment.userId,
            {
              'subscription.plan': targetPlan,`
);

// 2. Update initializeNotchPay to accept plan parameter and save metadata
code = code.replace(
  /static async initializeNotchPay\(\s*userId: any,\s*clientAmount: number,\s*type: 'deposit' \| 'subscription',\s*phone\?: string,\s*\)/,
  `static async initializeNotchPay(
    userId: any,
    clientAmount: number,
    type: 'deposit' | 'subscription',
    phone?: string,
    plan: 'premium' | 'business' = 'premium',
  )`
);

code = code.replace(
  /description: type === 'subscription' \? 'Abonnement Kauri Premium' : 'Recharge Portefeuille',/g,
  `description: type === 'subscription' ? \`Abonnement Kauri \${plan === 'business' ? 'Super Premium (Business)' : 'Premium'}\` : 'Recharge Portefeuille',`
);

// Update notchpay Payment.create to save metadata: { plan }
code = code.replace(
  /await Payment\.create\({\s*userId: userIdStr,\s*amount,\s*currency,\s*method: 'notchpay',\s*type,\s*reference,\s*status: 'pending',\s*externalReference: response\.data\.transaction\.reference,\s*}\);/,
  `await Payment.create({
        userId: userIdStr,
        amount,
        currency,
        method: 'notchpay',
        type,
        reference,
        status: 'pending',
        externalReference: response.data.transaction.reference,
        metadata: { plan },
      });`
);

// 3. Update createStripeSession to accept plan parameter
code = code.replace(
  /static async createStripeSession\(\s*userId: any,\s*clientAmount: number,\s*type: 'deposit' \| 'subscription',\s*\)/,
  `static async createStripeSession(
    userId: any,
    clientAmount: number,
    type: 'deposit' | 'subscription',
    plan: 'premium' | 'business' = 'premium',
  )`
);

code = code.replace(
  /name: type === 'subscription' \? 'Kauri Premium' : 'Wallet Deposit',/g,
  `name: type === 'subscription' ? \`Kauri \${plan === 'business' ? 'Super Premium (Business)' : 'Premium'}\` : 'Wallet Deposit',`
);

code = code.replace(
  /metadata: \{\s*userId: userIdStr,\s*type,\s*reference,\s*\},/g,
  `metadata: {
          userId: userIdStr,
          type,
          reference,
          plan,
        },`
);

code = code.replace(
  /await Payment\.create\({\s*userId: userIdStr,\s*amount,\s*currency,\s*method: 'stripe',\s*type,\s*reference,\s*status: 'pending',\s*externalReference: session\.id,\s*}\);/,
  `await Payment.create({
        userId: userIdStr,
        amount,
        currency,
        method: 'stripe',
        type,
        reference,
        status: 'pending',
        externalReference: session.id,
        metadata: { plan },
      });`
);

// 4. Update paySubscriptionWithWallet to accept plan parameter
code = code.replace(
  /static async paySubscriptionWithWallet\(userId: any\)/,
  `static async paySubscriptionWithWallet(userId: any, plan: 'premium' | 'business' = 'premium')`
);

code = code.replace(
  /const priceInfo = this\.getSubscriptionPrice\(user\.country\);/,
  `const priceInfo = plan === 'business' ? this.getBusinessSubscriptionPrice(user.country) : this.getSubscriptionPrice(user.country);`
);

code = code.replace(
  /description: 'Abonnement Kauri Premium \(Portefeuille\)',/g,
  `description: \`Abonnement Kauri \${plan === 'business' ? 'Super Premium (Business)' : 'Premium'} (Portefeuille)\`,`
);

code = code.replace(
  /metadata: \{\s*userId: userIdStr,\s*type: 'subscription',\s*reference,\s*\},/g,
  `metadata: { plan },`
);

code = code.replace(
  /'subscription\.plan': 'premium',/g,
  `'subscription.plan': plan,`
);

// Add getBusinessSubscriptionPrice if not present
if (!code.includes('getBusinessSubscriptionPrice(')) {
  const getSubMethod = `  private static getBusinessSubscriptionPrice(countryCode?: string | null): { amount: number; currency: string } {
    switch (countryCode) {
      case 'FR':
      case 'BE':
      case 'DE':
      case 'IT':
      case 'ES':
        return { amount: 12.0, currency: 'EUR' };
      case 'US':
      case 'CA':
      case 'GB':
        return { amount: 15.0, currency: 'USD' };
      case 'CM':
      default:
        return { amount: 5000.0, currency: 'XAF' };
    }
  }\n\n`;
  code = code.replace(/private static getSubscriptionPrice/, getSubMethod + '  private static getSubscriptionPrice');
}

// Update getSubscriptionPrice lookup for dynamic plan
code = code.replace(
  /const \{ amount, currency \} =\s*type === 'subscription'\s*\?\s*this\.getSubscriptionPrice\(user\.country\)\s*:\s*\{ amount: clientAmount, currency: user\.currency \|\| 'USD' \};/,
  `const { amount, currency } =
      type === 'subscription'
        ? (plan === 'business' ? this.getBusinessSubscriptionPrice(user.country) : this.getSubscriptionPrice(user.country))
        : { amount: clientAmount, currency: user.currency || 'USD' };`
);

code = code.replace(
  /const \{ amount, currency \} =\s*type === 'subscription'\s*\?\s*this\.getSubscriptionPrice\(user\.country\)\s*:\s*\{ amount: clientAmount, currency: user\.currency \|\| 'XAF' \};/,
  `const { amount, currency } =
      type === 'subscription'
        ? (plan === 'business' ? this.getBusinessSubscriptionPrice(user.country) : this.getSubscriptionPrice(user.country))
        : { amount: clientAmount, currency: user.currency || 'XAF' };`
);

fs.writeFileSync(filePath, code, 'utf8');
console.log('paymentService.ts successfully updated with plan support.');
