  <!-- Footer area: START -->  
  <div id="footer" class="width-layout">

  <div id="footer-design">

    {*
	<ul class="w3c-conformance">
	<li><a title="Explanation of Level Double-A Conformance" href="http://www.w3.org/WAI/WCAG2AA-Conformance"><img height="32" width="88" alt="Level Double-A conformance icon, W3C-WAI Web Content Accessibility Guidelines 2.0" src={'validators/wcag2AA.png'|ezimage()} longdesc="http://www.w3.org/WAI/WCAG2AA-Conformance" /></a></li>
    <li><a title="Valid XHTML 1.1" href="http://validator.w3.org/check?uri=referer"><img src={'validators/valid-xhtml11.png'|ezimage()} alt="Valid XHTML 1.1" height="31" width="88" longdesc="http://validator.w3.org" /></a></li>
    <li><a title="CSS Valido!" href="http://jigsaw.w3.org/css-validator/check/referer?profile=css3"><img style="border:0;width:88px;height:31px" src={'validators/vcss.gif'|ezimage()} alt="CSS Valido!" longdesc="http://jigsaw.w3.org" /></a></li>
	<li><a title="Sito conforme agli standard" href="http://www.totalvalidator.com/validator/Revalidate?revalidate=true"><img src={'validators/valid_n_xhtml_11.gif'|ezimage()} alt="Sito completamente conforme agli standard" /></a></li>
	<li><a title="Validatore accessibilit&agrave;" href="http://wave.webaim.org/report?url=http://{ezsys('hostname')}/"><img src={'validators/wavelogo.jpg'|ezimage()} alt="Validatore accessibilit&agrave;" /></a></li>
	<li><a title="Validatore WCAG 2.0" href="http://www.tawdis.net/ingles.html?lang=en&amp;url=http://{ezsys('hostname')}#wcag2"><img src={'validators/NombrePortal.jpg'|ezimage()} alt="Validatore WCAG 2.0" /></a></li>
	</ul>
	*}
	<address>

           {def $credits=fetch(content,node,hash(node_id,572255))
				$pagamento=fetch(content,node,hash(node_id,661013))
				$note=fetch(content,node,hash(node_id,572253))
				$dichiarazione=fetch(content,node,hash(node_id,572254))}
			Comune di Trento - Sede legale: via Belenzani, 19 - 38122 Trento - Telefono 0461 884111 - codice fiscale e partita IVA 00355870221 - © Copyright 2010<br />
			<a title="Leggi le istruzioni e le coordinate bancarie per effettuare i pagamenti verso il Comune di Trento" href={$pagamento.url_alias|ezurl()}>Modalità di pagamento</a> 
			- <a title="Leggi le note legali" href={$note.url_alias|ezurl()}>note legali</a> 
			- <a title="Leggi i credits" href={$credits.url_alias|ezurl()}>credits</a> 
			- <a title="Leggi la dichiarazione di accessibilit&agrave;" href={$dichiarazione.url_alias|ezurl()}>dichiarazione di accessibilit&agrave;</a> 
			- powered by <a href="http://www.ez.no" title="eZ Publish - Enterprise Content Management System Open Source">eZ publish</a> <br />
	</address>
  </div>
  
  </div>
  <!-- Footer area: END -->  
  </div>
  </div>
  <!-- Content area: END -->
