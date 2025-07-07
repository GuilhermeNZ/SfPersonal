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

}