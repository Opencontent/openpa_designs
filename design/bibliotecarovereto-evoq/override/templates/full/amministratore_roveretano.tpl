{ezpagedata_set( 'has_container', true() )}
<div  id="main-container" class="content-view-full class-{$node.class_identifier} layout-page">

    <section class="main-content">
        <div class="container">
            <div class="row">
                <div class="col-xs-12 col-md-9 col-lg-9 column-content">
                    <header>
                        <h2><span>{$node.name|wash}</span></h2>
                    </header>

                    <table class="table">
                        <tbody>
                            {foreach $node.object.contentobject_attributes as $attribute}
                                {if $node|has_attribute( $attribute.contentclass_attribute_identifier )}
                                    <tr>
                                        <td>{$attribute.contentclass_attribute_name}</td>
                                        <td>
                                            {attribute_view_gui attribute=$attribute}
                                        </td>
                                    </tr>
                                {/if}
                            {/foreach}
                        </tbody>
                    </table>

                </div>
                <aside class="col-xs-12 col-md-3 col-lg-3 column-sidebar sidebar-extra">
                    <a href="{$node.parent.url_alias|ezurl('no')}"><i class="fa fa-arrow-circle-left"></i>Torna all'archivio</a>
                    <hr class="spacer">
                    <div class="well well-dark">
                        <h4>{$node.parent.name}</h4>
                        <div class="text">
                            {attribute_view_gui attribute=$node.parent|attribute( 'description' )}
                        </div>
                    </div>
                </aside><!-- /.sidebar-extra -->
            </div>
        </div>
    </section><!-- /.events -->

    {* Info *}
    {include uri='design:parts/home/info.tpl'}
</div>
