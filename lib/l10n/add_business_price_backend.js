const fs = require('fs');
const filePath = 'd:/Projets/NodeJS/djangui-api/src/services/paymentService.ts';
let code = fs.readFileSync(filePath, 'utf8');

const businessPriceMethod = `  private static getBusinessSubscriptionPrice(countryCode?: string | null): { amount: number; currency: string } {
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

code = code.replace(
  /private static getSubscriptionPrice\(countryCode\?: string \| null\): \{ amount: number; currency: string \} \{/,
  businessPriceMethod + '  private static getSubscriptionPrice(countryCode?: string | null): { amount: number; currency: string } {'
);

fs.writeFileSync(filePath, code, 'utf8');
console.log('Successfully added getBusinessSubscriptionPrice to PaymentService class.');
