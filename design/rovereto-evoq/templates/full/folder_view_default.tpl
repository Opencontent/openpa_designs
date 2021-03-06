{* Folder - Full view *}
{include name=menu_control node=$node uri='design:parts/common/menu_control.tpl'}

{def $classes_parent_to_edit=array('file_pdf', 'news')
     $sezioni_per_tutti= openpaini( 'GestioneSezioni', 'sezioni_per_tutti' )
	 $style='col-odd'
}

<div class="class-{$node.object.class_identifier} row">
	<div class="col-md-12">

        <h1>{attribute_view_gui attribute=$node.data_map.name}</h1>
	
        {* DATA e ULTIMAMODIFICA *}
        {include name = last_modified
                 node = $node             
                 uri = 'design:parts/openpa/last_modified.tpl'}
    
        {* EDITOR TOOLS *}
        {include name = editor_tools
                 node = $node             
                 uri = 'design:parts/openpa/editor_tools.tpl'}
            
        {def $attributi_da_escludere = openpaini( 'GestioneAttributi', 'attributi_da_escludere' )
             $oggetti_senza_label = openpaini( 'GestioneAttributi', 'oggetti_senza_label' )
             $attributi_senza_link = openpaini( 'GestioneAttributi', 'attributi_senza_link' )
             $attributi_da_evidenziare = openpaini( 'GestioneAttributi', 'attributi_da_evidenziare', array())}
        
        <div class="attributi-principali clearfix">
            {def $show_image = true()}
            {if and( is_set( $node.data_map.section_image ), $node.data_map.section_image.data_int|eq(1) )}
                {set $show_image = false()}
            {/if}
            
            {if and( $show_image, is_set( $node.data_map.image ), $node.data_map.image.has_content )}        
                <div class="main-image pull-left">
                    {attribute_view_gui attribute=$node.data_map.image image_class='medium'}
                </div>        
            {/if} 
            
            {if and( is_set($node.data_map.description), $node.data_map.description.has_content )}
                {attribute_view_gui attribute=$node.data_map.description}
            {/if}
        </div>
        
        {if or( and( is_set( $node.data_map.gps ), $node.data_map.gps.has_content ),
                and( is_set($node.data_map.file), $node.data_map.file.has_content ),
                and( is_set($node.data_map.riferimenti), $node.data_map.riferimenti.has_content ) )}
            {include name = attributi_principali uri = 'design:parts/openpa/attributi_base.tpl' contentobject_attributes = array( $node.data_map.gps, $node.data_map.file, $node.data_map.riferimenti )}		
        {/if}       
        
        {* CORRELAZIONI - OGGETTI DIRETTAMENTE CORRELATI rispetto ad attributi specifici - DisplayBlocks/oggetti_correlati_centro *}   
        {include name = related_objects_attributes_spec 
                 node = $node
                 title = 'Informazioni correlate:'
                 oggetti_correlati = openpaini( 'DisplayBlocks', 'oggetti_correlati_centro' )
                 uri = 'design:parts/related_objects_attributes.tpl'}
    
        {*OGGETTI INVERSAMENTE CORRELATI smart*}
        {include name=reverse_related_objects 
                 node=$node 
                 title='Riferimenti:'
                 classe=$node.class_identifier
                 attrib='riferimento'
                 uri='design:parts/reverse_related_objects_specific_class_and_attribute.tpl'}
    
        {* FIGLI *}
        {def $page_limit = openpaini( 'GestioneFigli', 'limite_paginazione', 25 )
             $show_items=false()
             $children=''
             $children_count=''
             $classes=''
             $include_exclude=''
             $gallery=''}
    
        {if and( is_set( $node.data_map.classi_filtro ), $node.data_map.classi_filtro.has_content )}
            
            {set $classes = $node.data_map.classi_filtro.content|explode(',')}
            {def $virtual_classes = array()}
            {foreach $classes as $class}
                {set $virtual_classes = $virtual_classes|append( $class|trim() )}
            {/foreach}
            
            {if $node.data_map.subfolders.has_content}
                {def $virtual_subtree = array()}
                {foreach $node.data_map.subfolders.content.relation_list as $relation}
                    {set $virtual_subtree = $virtual_subtree|append( $relation.node_id )}
                {/foreach}
            {else}
                {def $virtual_subtree = array( ezini( 'NodeSettings', 'RootNode', 'content.ini' ) )}
            {/if}
            
            {def $sortArray = $node.object.main_node.sort_array
			     $order = $sortArray[0][0]}
		    {if array( 'published', 'name' )|contains( $order )|not()}
			   {set $order = 'published'}
			{/if}
            {if $sortArray[0][1]|eq( 1 )}
                {def $sortHash = hash( $order, 'asc' )}
            {else}
                {def $sortHash = hash( $order, 'desc' )}
            {/if}
            
            {def $search_hash = hash( 'subtree_array', $virtual_subtree,
                                      'offset', $view_parameters.offset,
                                      'limit', $page_limit,
                                      'class_id', $virtual_classes,
                                      'sort_by', $sortHash
                                      )
                 $search = fetch( ezfind, search, $search_hash )}
                 
            {set $children = $search['SearchResult']
                 $children_count = $search['SearchCount']
                 $show_items=true()}
            
        
        {elseif $node.object.data_map.show_children.data_int}
            {set $page_limit = openpaini( 'GestioneFigli', 'limite_paginazione', 20 )
                 $classes = openpaini( 'ExcludedClassesAsChild', 'FromFolder' )
                 $children = array()
                 $gallery = ''
                 $children_count = ''
                 $show_items=true()}
            
            {set $gallery=fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                            'offset', $view_parameters.offset,
                                                            'sort_by', $node.sort_array,
                                                            'class_filter_type', 'include',
                                                            'class_filter_array', array('image'),
                                                            'limit', $page_limit ) )}
            {if $gallery|count()|gt(0)}
            {node_view_gui view='line_gallery' content_node=$node}
            {/if}
    
            {* in caso di gallerie fotografiche *}
            {set $children=fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                              'offset', $view_parameters.offset,
                                                              'sort_by', $node.sort_array,
                                                              'class_filter_type', 'include',
                                                              'class_filter_array', array('gallery'),
                                                              'limit', $page_limit ) )}
            {if $children|count()|gt(0)}
                {set $style='col-odd'}
                {foreach $children as $child }                    
                    {node_view_gui view='line_gallery' content_node=$child}                    
                {/foreach}
            {/if}
            
            {* FIGLI *}
            {include name = filtered_children 
                     node = $node.object.main_node 
                     object = $node.object
                     classes_figli = openpaini( 'GestioneClassi', 'classi_figlie_da_includere' )
                     classes_figli_escludi = openpaini( 'GestioneClassi', 'classi_figlie_da_escludere' )
                     classes_parent_to_edit = $classes_parent_to_edit
                     title='Allegati'
                     classi_da_non_commentare = openpaini( 'GestioneClassi', 'classi_da_non_commentare', array( 'news', 'comment' ) )
                     oggetti_correlati = openpaini( 'DisplayBlocks', 'oggetti_correlati' )
                     uri = 'design:parts/filtered_children.tpl'}
            
            {* in generale *}
            {set $classes =  openpaini( 'ExcludedClassesAsChild', 'FromFolder' )
                 $children = fetch( 'content', 'list', hash( 'parent_node_id', $node.node_id,
                                                              'offset', $view_parameters.offset,
                                                              'sort_by', $node.sort_array,
                                                              'class_filter_type', 'exclude',
                                                              'class_filter_array', $classes,
                                                              'limit', $page_limit ) )
                 $children_count=fetch( 'content', 'list_count', hash( 'parent_node_id', $node.node_id,
                                                                        'class_filter_type', 'exclude',
                                                                        'class_filter_array', $classes ) )}
        {/if}
    
        {*ALTRI FIGLI*}
        {if $show_items}
            {if $children_count|gt(0)}
                {foreach $children as $child }                
                    {node_view_gui view='line' show_image='no' content_node=$child}
                {/foreach}
                {include name=navigator
                         uri='design:navigator/google.tpl'
                         page_uri=$node.url_alias
                         item_count=$children_count
                         view_parameters=$view_parameters
                         item_limit=$page_limit}
            {/if} 
        {/if}
        
        {* TIP A FRIEND *}
        {include name=tipafriend node=$node uri='design:parts/common/tip_a_friend.tpl'}

    </div>
</div>