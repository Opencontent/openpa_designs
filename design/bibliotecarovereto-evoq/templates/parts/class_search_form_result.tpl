{def $counter = 1}

<h2>Risultati della ricerca</h2>
<p class="navigation">
  {foreach $data.fields as $field}
  <a class="btn btn-xs btn-info" href={concat( $page_url, $field.remove_view_parameters )|ezurl()}>
	<i class="fa fa-close"></i> <strong>{$field.name|wash()}:</strong> {$field.value|wash()}
  </a>
  {/foreach}
  <a class="btn btn-xs btn-danger" href={$page_url|ezurl()}>Annulla ricerca</a>
</p>

{if $data.count}
    <ul class="row list-unstyled list-boxed">
        {foreach $data.contents as $child }
            <li class="col-xs-12 col-md-6 col-lg-6 item">
                {node_view_gui view='line' content_node=$child}
            </li>
            {if eq($counter|mod(2), 0)}
                <li class="col-md-12 spacer"></li>
            {/if}
            {set $counter = $counter|sum(1) }
        {/foreach}
    </ul>
    {include name=navigator
		uri='design:navigator/google.tpl'
		page_uri=$page_url
		item_count=$data.count
		view_parameters=$view_parameters
		item_limit=$page_limit}
{else}
  <div class="warning">Nessun risultato</div>
{/if}
