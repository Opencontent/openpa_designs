{def $footer_notes = fetch( 'openpa', 'footer_notes' )}
<div class="col-lg-3 col-md-3 col-sm-3 m_xs_bottom_30 m_top_20">
    <h3 class="color_light_2 m_bottom_20">{fetch('openpa','homepage').name|wash()}</h3>
    {if $footer_notes}
        <div class="block">{attribute_view_gui attribute=$footer_notes}</div>
    {/if}
</div>