/**
 * @description: Class to provide stored Profile collections to PP components
 * @author: Guilherme Zwipp
 */
public virtual class PP_ProfileRepository {

    private static PP_ProfileRepository instance;

    public static PP_ProfileRepository getInstance() {
        if( instance == null ) instance = new PP_ProfileRepository();
        return instance;
    }

    protected PP_ProfileRepository(){}

    public virtual Profile byId( Id profileId ) {
        return [
            SELECT
                Id
                , Name
            FROM
                Profile
            WHERE Id = :profileId
            LIMIT 1
        ];
    }

}