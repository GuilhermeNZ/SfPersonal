public with sharing class StringHelper {
    public static String removeLineBreakCharacters( String stringWithLineBreak ) {
        return stringWithLineBreak.replace('\n','').replace('\t','').replace('\r','');
    }
}