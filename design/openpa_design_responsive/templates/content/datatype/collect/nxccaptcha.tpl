{ezcss_require( array( 'nxc.captcha.css' ) )}
{ezscript_require( array( 'nxc.captcha.js' ) )}

{def
	$class_content = $attribute.contentclass_attribute.content
	$collection_attribute = $#collection_attributes[$attribute.id]
	$regenerate = 1
}
{if ezhttp( 'ActionCollectInformation', 'post', true() )}
	{set $regenerate = 0}
{/if}

{if eq( $collection_attribute.data_int, 0 )}
	<p>Inserisci il testo che comapre nell'immagine</p>
	<img id="nxc-captcha-{$attribute.id}" alt="{'Secure code'|i18n( 'extension/nxc_captcha' )}" title="{'Secure code'|i18n( 'extension/nxc_captcha' )}" src="{concat( 'nxc_captcha/get/', $attribute.contentclass_attribute.id, '/nxc_captcha_collection_attribute_', $attribute.id, '/', $regenerate )|ezurl( 'no' )}" />
    <a href="{concat( 'nxc_captcha/get/', $attribute.contentclass_attribute.id, '/nxc_captcha_collection_attribute_', $attribute.id, '/1' )|ezurl( 'no' )}" class="nxc-captcha-regenerate" id="nxc-captcha-regenerate-{$attribute.id}">Rigenera</a>
	<p>
		<input class="captcha-input form-control" id="nxc-captcha-collection-input-{$attribute.id}" type="text" name="nxc_captcha_{$attribute.id}" value="{$collection_attribute.data_text}" size="{$class_content.length.value}" maxlength="{$class_content.length.value}" />		
	</p>
{else}
	<p>Codice di sicurezza inserito correttamente</p>
	<input type="hidden" name="nxc_captcha_{$attribute.id}" value="{$collection_attribute.data_text}" />
{/if}

{undef $class_content $collection_attribute $regenerate}