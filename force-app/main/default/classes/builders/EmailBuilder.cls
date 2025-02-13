/**
 * @description: Class responsible to build Messaging.SingleEmailMessage SObject
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class EmailBuilder {

    private Messaging.SingleEmailMessage email;

    public EmailBuilder() {
        this.email = new Messaging.SingleEmailMessage();
    }

    public EmailBuilder withAddress( String address ) {
        this.email.setToAddresses( new List<String>{ address } );
        return this;
    }

    public EmailBuilder withSenderDisplayName( String senderDisplayName ) {
        this.email.setSenderDisplayName( senderDisplayName );
        return this;
    }

    public EmailBuilder withSubject( String subject ) {
        this.email.setSubject( subject );
        return this;
    }

    public EmailBuilder withPlainTextBody( String plainTextBody ) {
        this.email.setPlainTextBody( plainTextBody );
        return this;
    }

    public Messaging.SingleEmailMessage build() {
        return this.email;
    }

}