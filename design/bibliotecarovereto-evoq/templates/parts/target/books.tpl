{set_defaults( hash(
  'item', $node
))}

{def $parent_node = fetch( 'content', 'node', hash( 'node_id', ezini( 'NodeSettings', 'ProposedBooksNodeID', 'content.ini' ) ) )
     $nodes = fetch( ezfind, search, hash(
        'class_id', array( 'libro' ),
        'filter', array( concat( solr_meta_subfield('target','id'),':',  $item.contentobject_id ) ),
        'subtree_array', array( $parent_node.node_id ),
        'limit', 2,
        'sort_by', hash( 'published', 'desc' )))
     $books_facet= fetch( ezfind, search, hash(
        'class_id', array( 'libro' ),
        'facet', array( hash( 'field','libro/tipologia', 'limit', 20 ) ),
        'limit', 2,
        ))}

{if $nodes.SearchCount|gt(0)}
    <section class="books">
        <div class="container">
            <div class="row">
                <div class="col-sm-12">
                    <div class="btn-group pull-right btn-filter">
                        <button type="button" class="btn btn-default btn-block dropdown-toggle" data-toggle="dropdown">
                            <i class="icon-libro"></i> Libri consigliati <span class="caret"></span>
                        </button>
                        <ul class="dropdown-menu" role="menu">
                            {foreach $books_facet.SearchExtras.facet_fields[0].nameList as $t}
                                {if $t}
                                    <li><a href="{concat($books_facet.SearchResult[0].parent.url_alias|ezurl(no), '/(attribute', $books_facet.SearchResult[0].data_map.tipologia.contentclassattribute_id, ')/', $t, '/(class_id)/', $books_facet.SearchResult[0].object.contentclass_id)}">{$t}</a></li>
                                {/if}
                            {/foreach}
                        </ul>
                    </div><!-- ./btn-filter -->
                    <h2 class="text-center title">Il bibliotecario propone...</h2>
                </div>
            </div>
            <ul class="row list-unstyled list-preview">
                {foreach $nodes.SearchResult as $n}
                    {include uri=concat('design:parts/home/line/', $n.class_identifier, '.tpl')
                        item=$n
                    }
                {/foreach}
            </ul>
            <div class="row">
                <div class="col-sm-4 col-sm-offset-4">
                    <a href="{'Patrimonio-e-risorse/Libri'|ezurl('no')}" class="btn btn-default btn-lg btn-block btn-dark text-uppercase">Mostra altri libri</a>
                </div><!-- /.col-sm-4 -->
            </div>
        </div>
    </section><!-- /.books -->
{/if}

{undef $parent_node $nodes $books_facet}
