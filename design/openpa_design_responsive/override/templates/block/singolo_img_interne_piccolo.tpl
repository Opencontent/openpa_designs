{def $valid_node = $block.valid_nodes[0]}

<div class="ezpage-block {$block.view}{if is_set($block.custom_attributes.color)} color color-{$block.custom_attributes.color}{/if}">
    {if $block.name}<h2>{$block.name}</h2>{/if}
    {if and( is_set($valid_node.data_map.image), $valid_node.data_map.image.has_content )}
    {attribute_view_gui href=$valid_node.url_alias|ezurl() alt=$valid_node.name|wash() attribute=$valid_node.data_map.image image_class='singolo_interne' }
    {/if}
</div>    
