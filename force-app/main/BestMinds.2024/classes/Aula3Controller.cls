public with sharing class Aula3Controller {
    @AuraEnabled
    public static Aula3Service.CEPObjTO getAddressWithIntegration ( String cep ) {
        return Aula3Service.getAddressWithIntegration( cep );
    }

    @AuraEnabled
    public static Boolean saveAddressInformation ( Id accountId, Aula3Service.CEPObjTO addressInformations ) {
        return Aula3Service.saveAddressInformation( accountId, addressInformations );
    }

    @AuraEnabled
    public static Boolean sendEmailError(String errorMessage){
        // Create a new email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        // Set the email properties
        mail.setSubject('Subject of the Email');
        mail.setPlainTextBody(errorMessage); // You can also use setHtmlBody() for HTML content
        mail.setToAddresses(new String[] {'reiryssonjp@gmail.com'});
        // mail.setCcAddresses(new String[] {'cc@example.com'}); // Optional
        // mail.setBccAddresses(new String[] {'bcc@example.com'}); // Optional

        // If you want to include attachments, you can add them like this:
        // List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        // Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        // attachment.setFileName('Attachment.txt');
        // attachment.setBody(Blob.valueOf('Attachment Content'));
        // attachments.add(attachment);
        // mail.setFileAttachments(attachments);

        // Send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        return true;
    }
}