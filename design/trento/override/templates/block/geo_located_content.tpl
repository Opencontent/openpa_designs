{if and( is_set( $block.custom_attributes.limit ), 
            ne( $block.custom_attributes.limit, '' ) )}
    {def $limit = $block.custom_attributes.limit}
{else}
    {def $limit = '5'}
{/if}

{if and( is_set( $block.custom_attributes.width ), 
            ne( $block.custom_attributes.width, '' ) )}
    {def $width = $block.custom_attributes.width}
{else}
    {def $width = '460'}
{/if}

{if and( is_set( $block.custom_attributes.height ), 
            ne( $block.custom_attributes.height, '' ) )}
    {def $height = $block.custom_attributes.height}
{else}
    {def $height = '600'}
{/if}

{def $locations = fetch( 'content', 'tree', hash( 'parent_node_id', $block.custom_attributes.parent_node_id,
                                                  'class_filter_type', 'include',
                                                  'class_filter_array', array( $block.custom_attributes.class ),
                                                  'sort_by', array( 'name', true() ),
                                                  'limit', $limit ) )
     $attribute = $block.custom_attributes.attribute}

{def $domain=ezsys( 'hostname' )|explode('.')|implode('_')}


<h2 class="block-title">{$block.name|wash()}</h2>

<div id="ezflb-map-{$block.id}" class="block-map" style="float: left; width: {$width}px; height: {$height}px"></div>

<div id="ezflb-map-right" class="block-markers" style="float: left; width: 30%; margin-right:5px">
<ul>
{foreach $locations as $index => $location}
{if $location.data_map[$attribute].has_content}
    <li><a id="ezflb-map-{$block.id}-{$index}" href="{$location.url_alias|ezurl('no')}">{$location.name|wash()}</a></li>
{/if}    
{/foreach}
</ul>
</div>

<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
{ezscript_require( 'ezflgmapview.js' )}

<script type="text/javascript">
<!--
       
var data_{$block.id} = [];

{foreach $locations as $location}
{if $location.data_map[$attribute].has_content}

data_{$block.id}.push( {ldelim}

    "lat": {$location.data_map[$attribute].content.latitude},
    "lng": {$location.data_map[$attribute].content.longitude},
    "description": "<h3><a href='{$location.url_alias|ezurl('no')}'>{$location.name|wash()}</a></h3>{$location.data_map[$attribute].content.address}",
    "title": "{$location.name|wash()}"
{rdelim} );

{/if}
{/foreach}

google.maps.event.addDomListener(window, 'load',
    function(){ldelim}
        eZFLGMapView(
            'ezflb-map-{$block.id}',
            new google.maps.LatLng(data_{$block.id}[0].lat,data_{$block.id}[0].lng),
            13,
            data_{$block.id} );
    {rdelim} );

-->
</script>




