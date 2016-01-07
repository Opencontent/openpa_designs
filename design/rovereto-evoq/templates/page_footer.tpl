{* Chiusura del div.container *}
</div>

{if is_area_tematica()}

  {def $show_logo = cond( and( is_set( is_area_tematica().data_map.show_search ), is_area_tematica().data_map.show_search.data_int|eq(1) ), true(), false() )
	   $show_footer = cond( and( is_set( is_area_tematica().data_map.footer ), is_area_tematica().data_map.footer.has_content ), true(), false() )}
  
  {if or( $show_footer, $show_logo )}
  <div id="footer">
	<div id="footer-contact" class="container">
		  <div class="row">
			  
			  {if $show_footer}
			  <div class="col-md-{if $show_logo}6{else}12{/if}">
				  {attribute_view_gui attribute=is_area_tematica().data_map.footer}
			  </div>
			  {/if}
			  
			  {if $show_logo}
			  <div class="col-md-6 {if $show_footer|not()}col-md-offset-6{/if}">
				  <h1 id="logo" class="pull-right">
                    <a href={"/"|ezurl} title="{ezini('SiteSettings','SiteName')}">
                        <img src="{'comune/stemma.jpg'|ezimage(no)}" alt="Stemma {ezini('SiteSettings','SiteName')}"/>
                        <span class="sitename">
                            <span class="main">{ezini('SiteSettings','SiteName')}</span>
                            <span class="detail">Provincia di Trento</span>
                        </span>
                    </a>            
                </h1>
			  </div>
			  {/if}
		  </div>
	  </div>
  </div>
  {/if}
  
{else}

{def $sections = openpaini( 'Sezioni', 'Sezione', array() )
     $comune = fetch( content, node, hash( node_id, $sections.comune ))
     $citta = fetch( content, node, hash( node_id, $sections.citta ))    
     $suffix = ''}

{if is_section(  'comune' )}
    {set $suffix = '-comune'}
{elseif is_section(  'citta' )}
    {set $suffix = '-citta'}
{/if}     

<div id="footer">
    
    <div id="footer-menu" style="background-image: none">
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <h4><a href="{$comune.url_alias|ezurl(no)}" title="Link a {$comune.name|wash()}">{$comune.name|wash()}</a></h4>
                    <ul>
                        {foreach $comune.children as $child}
                        {if openpaini( 'TopMenu', 'IdentificatoriMenu', array() )|contains($child.class_identifier)|not()}{skip}{/if}
                        <li><a href="{$child.url_alias|ezurl(no)}" title="Link a {$child.name|wash()}">{$child.name|wash()}</a></li>
                        {/foreach}
                    </ul>
                </div>
                <div class="col-md-4">
                    <h4><a href="{$citta.url_alias|ezurl(no)}" title="Link a {$citta.name|wash()}">{$citta.name|wash()}</a></h4>
                    <ul>
                        {foreach $citta.children as $child}
                        {if openpaini( 'TopMenu', 'IdentificatoriMenu', array() )|contains($child.class_identifier)|not()}{skip}{/if}
                        <li><a href="{$child.url_alias|ezurl(no)}" title="Link a {$child.name|wash()}">{$child.name|wash()}</a></li>
                        {/foreach}
                    </ul>
                </div>
                <div class="col-md-4">
                    <p class="social-links">
                        <a href="https://www.facebook.com/ComuneDiRovereto" title="Link a Facebook"><img src="{concat('comune/facebook',$suffix,'.png')|ezimage(no)}" alt="Facebook" /></a>
                        <a href="https://twitter.com/ComuneRovereto" title="Link a Twitter"><img src="{concat('comune/twitter',$suffix,'.png')|ezimage(no)}" alt="Twitter" /></a>
                        <span>Rovereto è social!</span>
                    </p>
                </div>
            </div>
        </div>
    </div>

    <div id="footer-contact" class="container">
        <div class="row">
            <div class="col-md-8 vcard">
                <p><strong class="fn org">Comune di Rovereto</strong></p>
                <p><span class="adr"><span class="street-address">piazza Podestà, 11</span> - <span class="postal-code">38068</span> <span class="locality">Rovereto</span> <abbr class="region" title="Trento">TN</abbr></span> - 
                    <span class="tel"><span class="type">tel.</span> 0464 452 111</span> -
                    <span class="tel"><span class="type">fax</span> 0464 452 433</span> <br />
                    e-mail <a class="email" href="mailto:urp@comune.rovereto.tn.it">{'urp@comune.rovereto.tn.it'|wash(email)}</a> {*- Skype <a class="email" href="skype:comune.rovereto.skype?call">comune.rovereto.skype</a> *}<br />
                    posta elettronica certificata (p.e.c.) <a class="email" href="mailto:comunerovereto.tn@legalmail.it">{'comunerovereto.tn@legalmail.it'|wash(email)}</a> <br />
                    partita iva / codice fiscale  00125390229
                </p>
            </div>
            <div class="col-md-4 info">
                {def $infos = cond( openpaini( 'LinkSpeciali', 'NodoInfos'), fetch( content, node, hash( node_id, openpaini( 'LinkSpeciali', 'NodoInfos') ) ), false())}
                
                <p><strong>Informazioni su questo sito web</strong></p>
                <ul>
                    {foreach $infos.children as $info}
                        <li><a href={$info.url_alias|ezurl()} title="Link a {$info.name|wash()}">{$info.name|wash()}</a></li>
                    {/foreach}                    
                    {if $current_user.is_logged_in}
                    <li id="logout"><a href={"/user/logout"|ezurl} title="Esegui il logout">Esci ( {$current_user.contentobject.name|wash} )</a></li>
                    {else}
                    <li><a href={concat("/user/login?url=",$module_result.uri)|ezurl} title="Login al sistema">Accesso redazione</a></li>
                    {/if}
                </ul>
            </div>
        </div>
    </div>
    
</div>

{/if}