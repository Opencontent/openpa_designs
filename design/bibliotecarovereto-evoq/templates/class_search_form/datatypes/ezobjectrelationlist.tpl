{* 'view' possibili: select|radio|checkbox *}
{def $values = $input.values
	 $_view = 'select'}
	 
{if count($values)|gt(0)}
  {include uri = concat( 'design:class_search_form/form_fields/', $_view, '.tpl' )
		   label = $input.class_attribute.name
		   input_name = $input.name
		   id = concat('search-for-',$input.id)
		   values = $values}
{/if}

{undef $values $_view}