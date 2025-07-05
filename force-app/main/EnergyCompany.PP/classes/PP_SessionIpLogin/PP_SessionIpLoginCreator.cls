/**
 * @description: Class responsible for creating SessionIpLogin__c records based on parameters
 * @author: Guilherme Zwipp
 */
public with sharing class PP_SessionIpLoginCreator {

    SessionIpLoginRepository sessionIpLoginRepositoryInstance;
    PP_SessionIpLoginSettingRepository pp_SessionIpLoginSettingRepositoryInstance;
    PP_ProfileRepository pp_profileRepositoryInstance;

    public PP_SessionIpLoginCreator() {
        this.SessionIpLoginRepositoryInstance = sessionIpLoginRepository.getInstance();
        this.pp_SessionIpLoginSettingRepositoryInstance = PP_SessionIpLoginSettingRepository.getInstance();
        this.pp_profileRepositoryInstance = PP_ProfileRepository.getInstance();
    }

    private final Integer DEFAULT_EXPIRATION_TIME = 24;

    public SessionIpLogin__c byUserSourceIpAndUserIdAndLoginStartDateAndProfileId( String sourceIp, Id userId, DateTime loginStartDate, Id profileId ) {
        SessionIpLogin__c sessionIpLogin = new SessionIpLoginBuilder()
            .withSourceIp( sourceIp )
            .withUserId( userId )
            .withLoginStartDate( loginStartDate )
            .withLoginExpirationDate( loginStartDate.addHours( this.getExpirationTime( profileId ) ) )
            .build();

        return (SessionIpLogin__c) this.sessionIpLoginRepositoryInstance.save( sessionIpLogin );
    }

    private Integer getExpirationTime( Id profileId ) {
        Map<String, SessionIpLoginSetting__mdt> sessionIpSettingByDeveloperName = this.pp_SessionIpLoginSettingRepositoryInstance.getAll();

        String profileName = this.pp_profileRepositoryInstance.byId( profileId ).Name.replaceAll( ' ', '' );

        if( sessionIpSettingByDeveloperName.containsKey( profileName ) ){
            return Integer.valueOf( sessionIpSettingByDeveloperName.get( profileName ).ExpirationTime__c );
        }

        return DEFAULT_EXPIRATION_TIME;
    }

}