{def $_redirect = false()}
{if ezhttp_hasvariable( 'LastAccessesURI', 'session' )}
    {set $_redirect = ezhttp( 'LastAccessesURI', 'session' )}
{elseif $object.main_node_id}
    {set $_redirect = concat( 'content/view/full/', $object.main_node_id )}
{elseif ezhttp( 'url', 'get', true() )}
    {set $_redirect = ezhttp( 'url', 'get' )|wash()}
{/if}  
<form class="edit" enctype="multipart/form-data" method="post" action={concat("/content/edit/",$object.id,"/",$edit_version,"/",$edit_language|not|choose(concat($edit_language,"/"),''))|ezurl}>
    {include uri='design:parts/website_toolbar_edit.tpl'}
    
    {include uri="design:parts/openpa/edit_copy_warning.tpl"}
    {include uri="design:content/edit_validation.tpl"}
    
    <div class="pull-right">
        {def $language_index = 0
             $from_language_index = 0
             $translation_list = $content_version.translation_list}
    
        {foreach $translation_list as $index => $translation}
           {if eq( $edit_language, $translation.language_code )}
              {set $language_index = $index}
           {/if}
        {/foreach}
    
        {if $is_translating_content}
    
            {def $from_language_object = $object.languages[$from_language]}
    
            {'Translating content from %from_lang to %to_lang'|i18n( 'design/ezwebin/content/edit',, hash(
                '%from_lang', concat( $from_language_object.name, '&nbsp;<img src="', $from_language_object.locale|flag_icon, '" style="vertical-align: middle;" alt="', $from_language_object.locale, '" />' ),
                '%to_lang', concat( $translation_list[$language_index].locale.intl_language_name, '&nbsp;<img src="', $translation_list[$language_index].language_code|flag_icon, '" style="vertical-align: middle;" alt="', $translation_list[$language_index].language_code, '" />' ) ) )}
    
        {else}
    
            {'Content in %language'|i18n( 'design/ezwebin/content/edit',, hash( '%language', $translation_list[$language_index].locale.intl_language_name ))}&nbsp;<img src="{$translation_list[$language_index].language_code|flag_icon}" style="vertical-align: middle;" alt="{$translation_list[$language_index].language_code}" />
    
        {/if}
    </div>

    <h2>{"Edit %1 - %2"|i18n("design/standard/content/edit",,array($class.name|wash,$object.name|wash))}</h2>
    
    
    <div class="row">

        <div class="col-md-12">
                
            {include uri="design:content/edit_attribute.tpl"}
        
            <div class="buttonblock">
                <input class="defaultbutton" type="submit" name="PublishButton" value="{'Send for publishing'|i18n('design/standard/content/edit')}" />
                <input class="button" type="submit" name="StoreButton" value="{'Store draft'|i18n('design/standard/content/edit')}" />
                <input class="button" type="submit" name="DiscardButton" value="{'Discard'|i18n('design/standard/content/edit')}" />
                <input type="hidden" name="RedirectIfDiscarded" value="{$_redirect|wash()}" />
                <input type="hidden" name="RedirectURIAfterPublish" value="{$_redirect|wash()}" />
            </div>
        </div>        
</div>   
</form>

{undef $_redirect}