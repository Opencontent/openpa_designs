{ezpagedata_set( 'has_container', true() )}
{def $css_page = 'col-xs-12 col-md-12 col-lg-12'
     $sidebar = false()
     $filter_tools = false()}
{if $node|has_attribute( 'image' )}
    {set $sidebar = true()
         $css_page = 'col-xs-12 col-md-9 col-lg-9'}
{/if}


<div id="main-container" class="layout-page">

    <section class="main-content">
        <div class="container">
            <div class="row">
                <div class="{$css_page} column-content">

                    <header>
                        <h2>{$node.name|wash}</h2>
                        <div class="lead">{attribute_view_gui attribute=$node|attribute( 'abstract' )}</div>
                    </header>

                    <div class="text">
                        {attribute_view_gui attribute=$node|attribute( 'description' )}
                    </div>

                    {*if $node|has_attribute( 'children_view' )}
                        {include uri=concat('design:parts/children/', $node.data_map.children_view.class_content.options[$node.data_map.children_view.value[0]].name|downcase(), '.tpl')}
                    {else}
                        {include uri='design:parts/children.tpl' view='line'}
                    {/if*}

                </div><!-- /.column-content -->

                {if $node|has_attribute( 'image' )}
                    <aside class="col-xs-12 col-md-3 col-lg-3 column-sidebar sidebar-extra">
                        {*Modulo di ricerca*}
                        {*if $node.data_map.classi_filtro.has_content}
                            {class_search_form( $node.data_map.classi_filtro.content, hash( 'RedirectNodeID', $node.node_id ) )}
                        {/if*}
                        <figure class="thumbnail">
                            {attribute_view_gui attribute=$node|attribute( 'image' ) href=false() use_html5_tag=true() image_class='event_line'  css_class=false() image_css_class="img-responsive"}
                        </figure>
                    </aside><!-- /.sidebar-extra -->
                {/if}
            </div>
        </div>
    </section><!-- /.events -->

    <section class="gray">
        <div class="container">
            {include uri='design:parts/children/filters.tpl' view='line'}
        </div>
    </section>


    {* Info *}
    {include uri='design:parts/home/info.tpl'}
</div>
