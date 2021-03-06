{def    $customs=$block.custom_attributes 
		$errors=false() 
		$sort_array=array('published', false())
		$classes=array()
		$titolo_articolo =""
		$url_articolo =""
		$facetParameters  = fetch( ezfind, facetParameters )
     	$curr_ts = currentdate()	 
		$curr_today = $curr_ts|datetime( custom, '%j')
    	$curr_year = $curr_ts|datetime( custom, '%Y')
    	$curr_month = $curr_ts|datetime( custom, '%n')
		$date = concat('published:[', $curr_year, '-',$curr_month,'-',$curr_today,'T00:00:00.000Z TO ', $curr_year, '-',$curr_month,'-',$curr_today,'T00:00:00.000Z]')
		$oggi = makedate($curr_month, $curr_today, $curr_year)
}

{if $customs.limite|gt(0)}
    {def $limit=$customs.limite}
{else}
    {def $limit=15}
{/if}

{if $customs.livello_profondita|eq('')}
    {def $depth=1}
{else}
    {def $depth=$customs.livello_profondita}
{/if}

{def $nodo=fetch(content,node,hash(node_id,$customs.node_id))}
{switch match=$customs.ordinamento}
{case match=''}
    {set $sort_array=$nodo.sort_array}
{/case}
{case match='priorita'}
        {set $sort_array=array('priority', true())}
{/case}
{case match='pubblicato'}
        {set $sort_array=array('published', false())}
{/case}
{case match='modificato'}
        {set $sort_array=array('modified', false())}
{/case}
{case match='nome'}
        {set $sort_array=array('name', true())}
{/case}
{case}{/case}
{/switch}

{if $customs.includi_classi|eq('articolo')}
    {set $classes=$customs.includi_classi|explode(',')}
    {def $children=fetch( 'content', 'tree', hash( 'parent_node_id', $customs.node_id,
                                                    'class_filter_type', 'include',
                                                    'class_filter_array', $classes,
                                                    'depth', $depth,
                                                    'limit', $limit,
                                                    'sort_by', array('published', false()) 
							     ) )}

{elseif $customs.includi_classi|ne('')}
    {set $classes=$customs.includi_classi|explode(',')}
    {def $children=fetch( 'content', 'tree', hash( 'parent_node_id', $customs.node_id,
                                                    'class_filter_type', 'include',
                                                    'class_filter_array', $classes,
                                                    'depth', $depth,
                                                    'limit', $limit,
                                                    'sort_by', $sort_array) )}
{else}
    {set $classes = openpaini( 'GestioneClassi', 'classi_da_escludere_dai_blocchi_ezflow' )}
    {def $children=fetch( 'content', 'tree', hash( 'parent_node_id', $customs.node_id,
                                                    'class_filter_type', 'exclude',
                                                    'class_filter_array', $classes,
                                                    'depth', $depth,
                                                    'limit', $limit,
                                                    'sort_by', $sort_array) )}
{/if}


<div class="block-type-lista block-{$block.view}">

	{if $block.name}
		<h2 class="block-title">
			<a href={$nodo.url_alias|ezurl()} title="Vai a {$block.name|wash()}">{$block.name}</a>
		</h2>
	{/if}

{ezcss_require(array( 'overlay-gallery.css' ) )}
{ezscript_require(array( 'ezjsc::jquery', 'jcarousel.js', 'tools-expose.js', 'tools-overlay.js' ) )}

<script type="text/javascript">
{literal}
<!--//--><![CDATA[//><!--
$(document).ready(function() {
    var target = $('<div class="simple_overlay hide" id="gallery"><a class="prev">precedente</a><a class="next">successiva</a><div class="info"></div><img class="progress" alt="caricamento..." src={/literal}{'loading.gif'|ezimage()}{literal} /> </div>');
    $('body').append(target);
    $("#banner_carousel-{/literal}{$nodo.node_id}{literal}").jcarousel({scroll:2});
    $("#banner_carousel-{/literal}{$nodo.node_id}{literal} .attribute-image p.gallery a").overlay({ 
        target: '#gallery', 
        expose: '#f1f1f1' 
    }).gallery({ 
        speed: 800,
        template:'<a class="info-bottom" href=${title}>Apri articolo con tutti i dettagli</a><span>Articolo ${index} di ${total}</span>'
    });
});
//--><!]]>
{/literal}
</script>


<div class="banner-carousel photogallery float-break">

<ul id="banner_carousel-{$nodo.node_id}" class="jcarousel-list">

{foreach $children as $banner}
<li class="banner-carousel-item  jcarousel-item">
	<div class="attribute-name-title">
		<a href={$banner.url_alias|ezurl()} title="Leggi l'articolo completo">{$banner.name|wash}</a>
	</div>
	<div class="attribute-image">
		{set $titolo_articolo=concat("Articolo: ",$banner.name|wash)}
		{set url_articolo=$banner.url_alias|ezurl()}
		<p class="no-js-hide gallery">{attribute_view_gui attribute=$banner.data_map.image title=$url_articolo image_class=gallerythumbnail href=$banner.data_map.image.content.imagelargeoverlay.url|ezurl}</p>
		<p class="no-js-show">{attribute_view_gui attribute=$banner.data_map.image image_class=gallerythumbnail href=$banner.url_alias|ezurl}</p>
	</div>
	<div class="attribute-name">
		<p class="no-js-hide gallery-name">
			{if $banner.data_map.testata.has_content}
				Tratto da <strong> {attribute_view_gui href=nolink attribute=$banner.data_map.testata} </strong>
				{if $banner.data_map.pagina.content|ne(0)}
					a pagina {attribute_view_gui attribute=$banner.data_map.pagina}
					 {if $banner.data_map.pagina_continuazione.content|ne(0)}
                        e {attribute_view_gui attribute=$banner.data_map.pagina_continuazione}
					 {/if}
				{/if}
						
				{if $banner.data_map.autore.has_content}
		 			di {attribute_view_gui attribute=$banner.data_map.autore}
				{/if}
					
			{/if}
				    
			{if $banner.data_map.argomento_articolo.has_content}
		 		Su: <strong>{attribute_view_gui href=nolink attribute=$banner.data_map.argomento_articolo} </strong>
			{/if}
		</p>
		
	</div>
</li>
{/foreach}

</ul>

</div>

</div>