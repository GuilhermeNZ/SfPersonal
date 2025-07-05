/**
 * @description: Class to provide stored SessionIpLoginSetting__mdt collections to PP components
 * @author: Guilherme Zwipp
 */
public virtual class PP_SessionIpLoginSettingRepository {

    private static PP_SessionIpLoginSettingRepository instance;

    public static PP_SessionIpLoginSettingRepository getInstance() {
        if( instance == null ) instance = new PP_SessionIpLoginSettingRepository();
        return instance;
    }

    protected PP_SessionIpLoginSettingRepository(){}

    public virtual Map<String, SessionIpLoginSetting__mdt> getAll() {
        return SessionIpLoginSetting__mdt.getAll();
    }

}