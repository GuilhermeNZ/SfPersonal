/**
 * @description: Class responsible to build ContentVersion SObject
 * @author: Guilherme Zwipp - Everymind
 */
public with sharing class ContentVersionBuilder {
    
    private ContentVersion contentVersion;

    public ContentVersionBuilder() {
        this.contentVersion = new ContentVersion();
    }

    public ContentVersionBuilder withId( String Id ) {
        this.contentVersion.Id = id;
        return this;
    }

    public ContentVersionBuilder withVersionData( Blob versionData ) {
        this.contentVersion.VersionData = versionData;
        return this;
    }

    public ContentVersionBuilder withIsInsert( Boolean isInsert ) {
        this.contentVersion.isInsert__c = isInsert;
        return this;
    }

    public ContentVersionBuilder withObjectType( String objectType ) {
        this.contentVersion.ObjectType__c = objectType;
        return this;
    }

    public ContentVersionBuilder withContentDocumentId( String contentDocumentId ) {
        this.contentVersion.ContentDocumentId = contentDocumentId;
        return this;
    }

    public ContentVersionBuilder withPathOnClient( String pathOnClient ) {
        this.contentVersion.PathOnClient = pathOnClient;
        return this;
    }

    public ContentVersionBuilder withErrorsInInsert( String errors ) {
        this.contentVersion.ErrorsInInsert__c = errors;
        return this;
    }

    public ContentVersionBuilder withUserEmail( String userEmail ) {
        this.contentVersion.UserEmail__c = userEmail;
        return this;
    }

    public ContentVersionBuilder withIsExecuting( Boolean isExecuting ) {
        this.contentVersion.isExecuting__c = isExecuting;
        return this;
    }

    public ContentVersion build() {
        return this.contentVersion;
    }

}