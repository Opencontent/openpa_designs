{def $extra_info = 'extra_info'
     $left_menu = ezini('SelectedMenu', 'LeftMenu', 'menu.ini')
     $openpa = object_handler($node)
     $homepage = fetch('openpa', 'homepage')
     $current_user = fetch('user', 'current_user')
     $user_hash = concat( $current_user.role_id_list|implode( ',' ), ',', $current_user.limited_assignment_value_list|implode( ',' ) )}
{include uri='design:parts/openpa/wrap_full_open.tpl'}

{def $user_struttura_attribute_ID = openpaini( 'ControlloUtenti', concat('user_',$node.class_identifier,'_attribute_ID') )
	 $attributi_classificazione_strutture = openpaini( 'DisplayBlocks', 'attributi_classificazione_strutture' )		
	 $classes_parent_to_edit=array('file_pdf', 'news')
	 $classi_da_non_commentare=array('news', 'comment')
	 $current_user = fetch( 'user', 'current_user' )
     $attributi_da_escludere = openpaini( 'GestioneAttributi', 'attributi_da_escludere' )
     $oggetti_senza_label = openpaini( 'GestioneAttributi', 'oggetti_senza_label' )
     $attributi_senza_link = openpaini( 'GestioneAttributi', 'attributi_senza_link' )
     $attributi_da_evidenziare = openpaini( 'GestioneAttributi', 'attributi_da_evidenziare' )
}

{ezscript_require( array( 'ezjsc::jquery', 'jexcerpt.js', 'excerpt.js' ) )}

<div class="border-box">
<div class="border-content">

  <div class="global-view-full content-view-full">
   <div class="class-{$node.object.class_identifier}">

    <h1>{$node.name|wash()}</h1>
    
    {* DATA e ULTIMAMODIFICA *}
	{include name = last_modified
             node = $node             
             uri = 'design:parts/openpa/last_modified.tpl'}
             
	{*if and( is_set( $node.object.data_map.cod_servizio ), is_set( $node.object.data_map.cod_incarico ), is_set( $node.object.data_map.cod_ufficio ), is_set( $node.object.data_map.cod_struttura ), is_set( $node.object.data_map.cod_altrastruttura ) )}
	<div class="last-modified">Codice: 
        <strong>
            {attribute_view_gui attribute=$node.object.data_map.cod_servizio} 
            {if gt($node.object.data_map.cod_incarico,0)} .{attribute_view_gui attribute=$node.object.data_map.cod_incarico} {/if}
            {if gt($node.object.data_map.cod_ufficio,0)} .{attribute_view_gui attribute=$node.object.data_map.cod_ufficio} {/if}
            {if gt($node.object.data_map.cod_struttura,0)} .{attribute_view_gui attribute=$node.object.data_map.cod_struttura} {/if}
            {if gt($node.object.data_map.cod_altrastruttura,0)} .{attribute_view_gui attribute=$node.object.data_map.cod_altrastruttura} {/if}
        </strong>        
	</div>
    {/if*}

	{* EDITOR TOOLS *}
	{include name = editor_tools
             node = $node             
             uri = 'design:parts/openpa/editor_tools.tpl'}

	{* ATTRIBUTI : mostra i contenuti del nodo *}
    {include name = attributi_principali
             uri = 'design:parts/openpa/attributi_principali.tpl'
             node = $node}
	
	<div class="attributi-base">
	{def $style='col-odd' 
		 $attribute=''}
    
    {if and( is_set( $node.data_map.descrizione ), $node.data_map.descrizione.has_content )}
        {if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
        <div class="{$style} col float-break col-notitle">
            <div class="col-content"><div class="col-content-design">
            {attribute_view_gui attribute=$node.data_map.descrizione}
            </div></div>
        </div>
    {/if}
	
{* ------------------------------- sede ------------------------------- *}
	{if $node.data_map.sede.has_content}
	{set $attribute=$node.data_map.sede }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}
	
{* ------------------------------- indirizzo ------------------------------- *}
	{if $node.data_map.indirizzo.has_content}
	{set $attribute=$node.data_map.indirizzo }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}
	
{* ------------------------------- CAP ------------------------------- *}
	{if $node.data_map.cap.has_content}
	{set $attribute=$node.data_map.cap }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}


{* ------------------------------- telefoni-------------------------------  *}
	{if $node.data_map.telefoni.has_content}
	{set $attribute=$node.data_map.telefoni }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}


{* ------------------------------- fax -------------------------------  *}
	{if $node.data_map.fax.has_content}
	{set $attribute=$node.data_map.fax }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}	
	
{* ------------------------------- email -------------------------------  *}
	{if $node.data_map.email.has_content}
	{set $attribute=$node.data_map.email }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}		
	

{* ------------------------------- email secondaria-------------------------------  *}
	{if $node.data_map.email2.has_content}
	{set $attribute=$node.data_map.email2 }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}		
	
{* ------------------------------- email certificata-------------------------------  *}
	{if $node.data_map.email_certificata.has_content}
	{set $attribute=$node.data_map.email_certificata }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}		
	

{* ------------------------------- sito web-------------------------------  *}
	{if and( is_set( $node.data_map.url ), $node.data_map.url.has_content )}
	{set $attribute=$node.data_map.url }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}	
	
{* ------------------------------- responsabile ------------------------------- *}	
	{include struttura=$node style=$style icon=true uri='design:parts/ruoli_per_struttura.tpl'}    
	
{* ------------------------------- orario ------------------------------- *}
	{if $node.data_map.orario.has_content}
	{set $attribute=$node.data_map.orario }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">						
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}		

{* ------------------------------- articolazioni interne ------------------------------- *}
{include node=$node icon=false() uri='design:parts/articolazioni_interne.tpl'}
		
{* ------------------------------- riferimenti_utili-------------------------------  *}
	{if $node.data_map.riferimenti_utili.has_content}
	{set $attribute=$node.data_map.riferimenti_utili }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}	

{* ------------------------------- file ------------------------------- *}
	{if $node.data_map.file.has_content}
	{set $attribute=$node.data_map.file }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">						
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}	

{* ------------------------------- competenze ------------------------------- *}
	{if $node.data_map.competenze.has_content}
	{set $attribute=$node.data_map.competenze }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}		

{* ------------------------------- personale ------------------------------- *}
	{include struttura=$node style=$style icon=true uri='design:parts/personale_per_struttura.tpl'}	

{* ------------------------------- gps (mappa) -------------------------------  *}
	{if $node.data_map.gps.has_content}
	{set $attribute=$node.data_map.gps }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">						
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}

{* ------------------------------- ubicazione -------------------------------  *}
	{if is_set($node.data_map.ubicazione)}	
	{if $node.data_map.ubicazione.has_content}
	{set $attribute=$node.data_map.ubicazione }
		{if $attributi_da_escludere|contains($attribute.contentclass_attribute_identifier)|not()}
			{if $style|eq('col-even')}{set $style='col-odd'}{else}{set $style='col-even'}{/if}
				{if $oggetti_senza_label|contains($attribute.contentclass_attribute_identifier)|not()}
					<div class="{$style} col float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-title"><span class="label">{$attribute.contentclass_attribute_name}</span></div>
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui  attribute=$attribute}
						</div></div>
					</div>
				{else}
					<div class="{$style} col col-notitle float-break attribute-{$attribute.contentclass_attribute_identifier}">
						<div class="col-content"><div class="col-content-design">
							{attribute_view_gui attribute=$attribute}
						</div></div>
					</div>
				{/if}
		{/if}		
	{/if}	
	{/if}

	{* OGGETTI CORRELATI rispetto ad attributi specifici - oggetti_classificazione *}   
	{include name=classificazione_strutture 
             node=$node 
             title="Posizionamento nell'organigramma"
             attributi_classificazione=$attributi_classificazione_strutture
             uri='design:parts/classificazione_strutture.tpl'}

	
	</div>	

	</div>
  </div>
</div>
</div>

{include uri='design:parts/openpa/wrap_full_close.tpl'}