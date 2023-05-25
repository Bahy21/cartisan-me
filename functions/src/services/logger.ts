import * as  winston from 'winston';

const logger = winston.createLogger({
  level: 'info', // Set the desired logger.info level
  format: winston.format.json(), // Specify the logger.info format
  transports: [
    new winston.transports.Console(), // Output logs to the console
    new winston.transports.File({ filename: 'combined.logger.info' }) // Output logs to a file
  ]
});

export default logger;
