public with sharing class PpLoginScreenModalController {
    
    @AuraEnabled
    public static Boolean isReCAPTCHAValid(String tokenFromClient) {
        String SECRET_KEY = '6LcC8HkrAAAAADwe0dctdHELurBfMFU4pBGtGIfk';
        String RECAPTCHA_SERVICE_URL = 'https://www.google.com/recaptcha/api/siteverify';
        Http http = new Http();

        HttpRequest request = new HttpRequest();

        request.setEndpoint(RECAPTCHA_SERVICE_URL + '?secret=' + SECRET_KEY + '&response=' + tokenFromClient);
        request.setMethod('POST');
        request.setHeader('Content-Length', '0');
        HttpResponse response = http.send(request);

        Map<String, Object> mapOfBody = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

        System.debug('Return json from recaptcha: ' + JSON.serialize( mapOfBody ) );

        Boolean success = (Boolean) mapOfBody.get('success');

        return success;
    }

}