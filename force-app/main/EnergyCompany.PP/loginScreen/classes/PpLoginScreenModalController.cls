public with sharing class PpLoginScreenModalController {
    
    @AuraEnabled
    public static Boolean isReCAPTCHAValid( String tokenFromClient ) {

        HTTPCalloutService httpCalloutService = new HTTPCalloutService( 'ReCAPTCHA3' );
        httpCalloutService.setURLParameter( 'response', tokenFromClient );
        HttpResponse response = httpCalloutService.sendRequest();

        Map<String, Object> mapOfBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        System.debug('Return json from recaptcha: ' + JSON.serialize( mapOfBody ) );

        Boolean success = (Boolean) mapOfBody.get('success');

        return success;
    }

    @AuraEnabled
    public static String sendCodeToEmail( String userEmail ) {
        if ( String.isBlank( userEmail ) ) {
            throw new AuraHandledException( 'Email cannot be empty.' );
        }
        if ( !userEmail.contains( '@' ) || !userEmail.contains( '.' ) ) {
            throw new AuraHandledException( 'Invalid email format.' );
        }
        String code = String.valueOf( Math.abs( Crypto.getRandomInteger() ) ).leftPad( 6, '0' ).substring( 0, 6 );
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses( new List<String>{ userEmail } );
        email.setSubject( 'Your Verification Code' );
        email.setPlainTextBody( 'Your verification code is: ' + code );
        Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{ email } );
        System.debug( 'Verification code sent to email: ' + userEmail );
        return code;
    }

}