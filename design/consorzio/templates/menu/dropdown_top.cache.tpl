{def $top_menu_class_filter = openpaini( 'TopMenu', 'IdentificatoriMenu', array() )
     $custom_menu = openpaini( 'TopMenu', 'NodiCustomMenu', false() )
     $custom_aree = openpaini( 'TopMenu', 'NodiAreeCustomMenu', array() )
     $main_styles = openpaini( 'Stili', 'Nodo_NomeStile', array() )
     $hide_children = openpaini( 'TopMenu', 'NodiSoloPrimoLivello', array() )}

{ezscript_require( array( 'ezjsc::jqueryio', 'menu.js' ) )}


<div class="topmenu-design{if $custom_menu} custom{/if}">

    <h2 class="hide">Menu principale</h2>
	
    <ul id="topmenu-firstlevel">
	
	{if is_area_tematica()}
		
        {def $aree_tematiche = is_area_tematica().parent}			
		
        <li class="menu-area-tematica">
			<div><a href={is_area_tematica().url_alias|ezurl()}><span>{is_area_tematica().name|wash()}</span></a></div>
		</li> 		
		
        {def $aree_tematiche_level_2 = fetch('content','list', hash( 'parent_node_id', $aree_tematiche.node_id,
                                    		'sort_by', $aree_tematiche.sort_array, 'limit', 20,
                                        	'class_filter_type', 'include', 
                                        	'class_filter_array',  $top_menu_class_filter ) ) 
			 $aree_tematiche_level_2_class = array()
			 $aree_tematiche_level_2_count=0
			 $current_node_in_path_2 = first_set($pagedata.path_array[2].node_id, 0  )
			 $current_node_in_path_3 = cond( is_set( $pagedata.path_array[3] ), first_set($pagedata.path_array[3].node_id, 0  ), 0 )}
             
		<li id="menu-aree-tematiche" class="lastli aree-tematiche">
            <a href={$aree_tematiche.url_alias|ezurl()}>
                <span>{$aree_tematiche.name}</span>
            </a>														 
        
            {if $aree_tematiche_level_2|count()}
            <div class="secondlevel">
            <div class="menu-tl"><div class="menu-tr"><div class="menu-tc"></div></div></div>
            <div class="menu-ml"><div class="menu-mr"><div class="menu-mc float-break">
                <ul>
                {foreach $aree_tematiche_level_2 as $key => $item2}
                    {set $aree_tematiche_level_2_class = array()
                         $aree_tematiche_level_2_count = $aree_tematiche_level_2|count()}
                    {if $current_node_in_path_2|eq($item2.node_id)}
                        {set $aree_tematiche_level_2_class = array("selected")}
                    {/if}
                    {if $key|eq(0)}
                        {set $aree_tematiche_level_2_class = $aree_tematiche_level_2_class|append("subfirstli")}
                    {/if}
                    {if $aree_tematiche_level_2_count|eq( $key|inc )}
                        {set $aree_tematiche_level_2_class = $aree_tematiche_level_2_class|append("sublastli")}
                    {/if}
                    {if $item2.node_id|eq( $current_node_id )}
                        {set $aree_tematiche_level_2_class = $aree_tematiche_level_2_class|append("current")}
                    {/if}
                    {set $aree_tematiche_level_2_class = $aree_tematiche_level_2_class|append($item2.name|slugize())}
                    <li id="node_id_{$item2.node_id}"{if $aree_tematiche_level_2_class} class="{$aree_tematiche_level_2_class|implode(" ")}"{/if}><div><a title="Link a {$item2.name|wash()}" class="{$item2.name|slugize()}" href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item2.node_id)|ezurl}{else}{if $item2.node_id|eq($item2.main_node_id)}{$item2.url_alias|ezurl}{else}{$item2.object.main_node.url_alias|ezurl}{/if}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}>{$item2.name|wash()}</a></div></li>
                {/foreach}
            </ul>            
            </div></div></div>
            <div class="menu-bl"><div class="menu-br"><div class="menu-bc"></div></div></div>
            </div>
            {/if}
        </li>					
																 
	{else}		
					
        {if $custom_menu|not()}
            {* LIMITE DELLA FETCH DEL TOPMENU DI DEFAULT A 4 (QUATTRO) *}	
            {def $root_node=fetch( 'content', 'node', hash( 'node_id', $pagedata.root_node) )
                 $top_menu_items=fetch( 'content', 'list', hash( 'parent_node_id', $root_node.node_id,
                                                                  'sort_by', $root_node.sort_array,
                                                                  'class_filter_type', 'include',
                                                                  'class_filter_array', $top_menu_class_filter,
                                                                  'limit', openpaini( 'TopMenu', 'LimitePrimoLivello', 4 ) ) )
                 $current_node_in_path = first_set($pagedata.path_array[1].node_id, 0  )
                 $current_node_in_path_2 = first_set($pagedata.path_array[2].node_id, 0  )
                 $current_node_in_path_3 = cond( is_set( $pagedata.path_array[3] ), first_set($pagedata.path_array[3].node_id, 0  ), 0 )
            }
        {else}
            {def $top_menu_items=array()}
            {foreach $custom_menu as $menu_id}
                {set $top_menu_items = $top_menu_items|append( fetch( 'content', 'node', hash( 'node_id', $menu_id ) )  )}
            {/foreach}
            {def $root_node=false
                 $current_node_in_path = first_set($pagedata.path_array[1].node_id, 0  )
                 $current_node_in_path_2 = first_set($pagedata.path_array[2].node_id, 0  )
				 $current_node_in_path_3 = cond( is_set( $pagedata.path_array[3] ), first_set($pagedata.path_array[3].node_id, 0  ), 0 )}
            {if eq($pagedata.path_array[1].node_id, ezini('NodeSettings', 'RootNode', 'content.ini'))}
            	{set $current_node_in_path = first_set($pagedata.path_array[2].node_id, 0  )
                     $current_node_in_path_2 = first_set($pagedata.path_array[3].node_id, 0  )
					 $current_node_in_path_3 = cond( is_set( $pagedata.path_array[3] ), first_set($pagedata.path_array[3].node_id, 0  ), 0 )}
            {/if}
        {/if}
        
		{def $level_2_items_count = 0
        	 $top_menu_items_count = $top_menu_items|count()
			 $item_class = array()
			 $level_2_items = 0
			 $item_class_2 = array()
			 $level_3_items= array()
			 $item_class_3 = array()
             $level_3_items_count = 0
		}

		{if $top_menu_items_count}
		   {foreach $top_menu_items as $key => $item}
			    {set $item_class = cond($current_node_in_path|eq($item.node_id), array("selected"), array())
                     $level_2_items = array()}
                
                {if $hide_children|contains( $item.node_id )|not()}
                    {set $level_2_items = fetch( 'content', 'list', hash( 'parent_node_id', $item.node_id,
                                                                        'sort_by', $item.sort_array,
                                                                        'limit', cond( $custom_aree|contains( $item.node_id ), 50, openpaini( 'TopMenu', 'LimiteSecondoLivello', 20 ) ),
                                                                        'class_filter_type', 'include', 
                                                                        'class_filter_array', $top_menu_class_filter ) )}
                {/if}
                
				{if $key|eq(0)}
					{set $item_class = $item_class|append("firstli")}
				{/if}
				{if $top_menu_items_count|eq( $key|inc )}
					{set $item_class = $item_class|append("lastli")}
				{/if}
				{if $item.node_id|eq( $current_node_id )}
					{set $item_class = $item_class|append("current")}
				{/if}                
				
                {if is_set( $main_styles[$item.node_id] )}
                    {set $item_class = $item_class|append( $main_styles[$item.node_id]|slugize() )}
                {/if}

					<li id="node_id_{$item.node_id}"{if $item_class} class="{$item_class|implode(" ")}"{/if}>
                        <a class="{$item.name|slugize()}" href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item.node_id)|ezurl}{else}{$item.url_alias|ezurl}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}>
                            <span>{$item.name|wash()}</span>
                        </a>
                        {if $level_2_items|count()}
                            <div class="secondlevel">
                            <div class="menu-tl"><div class="menu-tr"><div class="menu-tc"></div></div></div>
                            <div class="menu-ml"><div class="menu-mr"><div class="menu-mc float-break">
                                <ul>
                                {foreach $level_2_items as $key => $item2}
                                    {set $item_class_2 = array()
                                         $level_2_items_count = $level_2_items|count()}
                                    {if $current_node_in_path_2|eq($item2.node_id)}
                                        {set $item_class_2 = array("selected")}
                                    {/if}
                                    {if $key|eq(0)}
                                        {set $item_class_2 = $item_class_2|append("subfirstli")}
                                    {/if}
                                    {if $level_2_items_count|eq( $key|inc )}
                                        {set $item_class_2 = $item_class_2|append("sublastli")}
                                    {/if}
                                    {if $item2.node_id|eq( $current_node_id )}
                                        {set $item_class_2 = $item_class_2|append("current")}
                                    {/if}
                                    {if $current_node_in_path_2|eq($item2.node_id)}
                                        {set $item_class_2 = array("selected")}
                                    {/if}
                                    {set $item_class_2 = $item_class_2|append($item2.name|slugize())}                                    
                                    <li id="node_id_{$item2.node_id}" class="count-{$level_2_items|count()}{if $item_class_2} {$item_class_2|implode(" ")}{/if}">
                                            <a title="{if is_set($item2.data_map.abstract)}{if $item2|has_abstract()}{$item2|abstract()|openpa_shorten()}{/if}{else}link a {$item2.name|wash()}{/if}" class="{$item2.name|slugize()}" href={if eq( $ui_context, 'browse' )}{concat("content/browse/", $item2.node_id)|ezurl}{else}{if $item2.node_id|eq($item2.main_node_id)}{$item2.url_alias|ezurl}{else}{if $item2.class_identifier|eq('area_tematica')}{$item2.object.main_node.url_alias|ezurl}{else}{$item2.url_alias|ezurl}{/if}{/if}{/if}{if $pagedata.is_edit} onclick="return false;"{/if}>
                                                {$item2.name|wash()}
                                            </a>
                                    {if $custom_aree|contains( $item.node_id )}
                                        {set $level_3_items=array()}
                                    {else}
                                        {set $level_3_items = fetch( 'content', 'list', hash(
                                                                                            'parent_node_id', $item2.node_id, 
                                                                                            'sort_by', $item2.sort_array,
                                                                                            'limit', openpaini( 'TopMenu', 'LimiteTerzoLivello', 10 ), 
                                                                                            'class_filter_type','include',
                                                                                            'class_filter_array', $top_menu_class_filter ) )}
                                    {/if}
                                    {if $level_3_items|count()|gt(0)}
                                    <ul class="thirdlevel float-break">
                                        {foreach $level_3_items as $item3}
                                            {set $item_class_3 = array()
                                                 $level_3_items_count = $level_3_items|count()}
                                            {if $current_node_in_path_3|eq($item3.node_id)}
                                                {set $item_class_3 = array("selected")}
                                            {/if}
                                            {if $key|eq(0)}
                                                {set $item_class_3 = $item_class_3|append("subfirstli")}
                                            {/if}
                                            {if $level_3_items_count|eq( $key|inc )}
                                                {set $item_class_3 = $item_class_3|append("sublastli")}
                                            {/if}
                                            {if $item3.node_id|eq( $current_node_id )}
                                                {set $item_class_3 = $item_class_3|append("current")}
                                            {/if}                                           
                                            <li class="thirdlevel-count-{$level_3_items|count()} {$item_class_3|implode(" ")}">
                                                    <a title="{if is_set($item3.data_map.abstract)}{if $item3.data_map.abstract.has_content}{$item3.data_map.abstract.content.output.output_text|explode("<br />")|implode(" ")|strip_tags()|trim()}{/if}{else}link a {$item3.name|wash()}{/if}" class="{$item3.name|slugize()}" href={if $item3.node_id|eq($item3.main_node_id)}{$item3.url_alias|ezurl}{else}{if $item3.class_identifier|eq('area_tematica')}{$item3.object.main_node.url_alias|ezurl}{else}{$item3.url_alias|ezurl}{/if}{/if}>
                                                        {$item3.name|wash()}
                                                    </a>
                                            </li>
                                        {/foreach}
                                    </ul>
                                    {/if}
                                    </li>
                                {/foreach}
                            </ul>
                            <ul class="menu-preview"></ul>
                            <div class="menu-default"><div class="menu-default-design float-break">
                                <h2><a href={$item.url_alias|ezurl()}>{$item.name|wash()}</a></h2>
                                {if and( is_set( $item.data_map.image ), $item.data_map.image.has_content )}
                                    <div class="object-left">{attribute_view_gui attribute=$item.data_map.image image_class=small href=$item.url_alias|ezurl()}</div>
                                {/if}
                                {if $item|has_abstract()}{$item|abstract()}{/if}
                            </div></div>
                        </div></div></div>
                        <div class="menu-bl"><div class="menu-br"><div class="menu-bc"></div></div></div>
                        </div>
                        {/if}				
                    </li>

			  {/foreach}
		{/if}
		{undef $level_2_items $root_node $top_menu_items $item_class $top_menu_items_count $current_node_in_path}
	{/if}    
    </ul>
    <div id="spinner-menu-detail"></div>
</div>
