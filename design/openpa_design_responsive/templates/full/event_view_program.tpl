{* Event Calendar - Full Program view *}
{def
    $event_node = $node.node_id
    $curr_ts = currentdate()
    $curr_today = $curr_ts|datetime( custom, '%j')
    $curr_year = $curr_ts|datetime( custom, '%Y')
    $curr_month = $curr_ts|datetime( custom, '%n')
    $temp_oldest_event = ''
    $temp_newest_event = ''

    $temp_offset = cond( ne($view_parameters.offset, ''), $view_parameters.offset, 0)
    $daymode = false()
    $direction = ""
    $newer_event_count = fetch( 'content', 'list_count', hash(
            'parent_node_id', $event_node,
            'class_filter_type',  'include',
            'class_filter_array', array( 'event' ),
               'attribute_filter',    array( 'or',
                    array( 'event/from_time', '>=', $curr_ts  ),
                    array( 'event/to_time', '>=', $curr_ts  )
            )    ))
    $older_event_count = fetch( 'content', 'list_count', hash(
            'parent_node_id', $event_node,
            'class_filter_type',  'include',
            'class_filter_array', array( 'event' ),
               'attribute_filter',
            array( 'and', array( 'event/from_time', '<', $curr_ts  ),
                    array( 'event/to_time', '<', $curr_ts  )
            )    ))
}
{if ge($temp_offset,0)}
{set $temp_offset = $temp_offset|abs}
{def $events = fetch( 'content', 'list', hash(
            'parent_node_id', $event_node,
            'sort_by', array( 'attribute', true(), 'event/from_time' ),
            'class_filter_type',  'include',
            'class_filter_array', array( 'event' ),
            'limit', 15,
            'offset', $temp_offset|mul(15),
            'attribute_filter', array( 'or',
                    array( 'event/from_time', '>=', $curr_ts  ),
                    array( 'event/to_time', '>=', $curr_ts  )
            )    ))
}
{set $newer_event_count = $newer_event_count|sub( 15|mul( $temp_offset|inc ) )}
{else}
{set $temp_offset = $temp_offset|abs|dec
     $direction = "-"}
{def $events = fetch( 'content', 'list', hash(
            'parent_node_id', $event_node,
            'sort_by', array( 'attribute', true(), 'event/from_time' ),
            'class_filter_type',  'include',
            'class_filter_array', array( 'event' ),
            'limit', 15,
            'offset', $temp_offset|mul(15),
            'attribute_filter', array( 'and',
                    array( 'event/from_time', '<', $curr_ts  ),
                    array( 'event/to_time', '<', $curr_ts  )
            )))
}
{set $older_event_count = $older_event_count|sub( 15|mul( $temp_offset|inc ) )}
{/if}

{foreach $events as $event}
{if or(eq($temp_newest_event,''),gt($event.object.data_map.from_time.content.timestamp, $temp_newest_event))}
    {set $temp_newest_event=$event.object.data_map.from_time.content.timestamp}
{/if}
{if or(eq($temp_oldest_event,''),lt($event.object.data_map.from_time.content.timestamp, $temp_oldest_event))}
    {set $temp_oldest_event=$event.object.data_map.from_time.content.timestamp}
{/if}
{/foreach}

{if eq($temp_oldest_event|datetime(custom,"%M"),  $temp_newest_event|datetime(custom,"%M"))}
{set $daymode=true()}
{/if}

<div class="row class-event-calendar event-calendar-programview">
    <div class="col-md-12">
    
        <h1>{$node.name|wash()}</h1>
    
        <ul class="pager">
        {if $direction}                
            {if $older_event_count|gt(0)}
                <li class="previous"><a href={concat("/content/view/full/",  $node.node_id, "/offset/-", $temp_offset|sum(2))|ezurl}>&larr; {"Past events"|i18n("design/ezwebin/full/event_view_program")}</a></li>
            {/if}
                    
            {if $temp_offset|gt(0)}
                <li class="next"><a href={concat("/content/view/full/",  $node.node_id, "/offset/-", $temp_offset)|ezurl}>{"Future events"|i18n("design/ezwebin/full/event_view_program")} &rarr;</a></li>
            {elseif $newer_event_count|gt(0)}
                <li class="next"><a href={concat("/content/view/full/",  $node.node_id, "/offset/0")|ezurl}>{"Future events"|i18n("design/ezwebin/full/event_view_program")} &rarr;</a></li>
            {/if}
        {else}
            {if $temp_offset|gt(0)}
                <li class="previous"><a href={concat("/content/view/full/",  $node.node_id, "/offset/", $temp_offset|dec)|ezurl}>&larr; {"Past events"|i18n("design/ezwebin/full/event_view_program")}</a></li>
            {elseif $older_event_count|gt(0)}
                <li class="previous"><a href={concat("/content/view/full/",  $node.node_id, "/offset/-1")|ezurl}>&larr; {"Past events"|i18n("design/ezwebin/full/event_view_program")}</a></li>
            {/if}
            {if $newer_event_count|gt(0)}
                <li class="next"><a href={concat("/content/view/full/",  $node.node_id, "/offset/", $temp_offset|inc)|ezurl}>{"Future events"|i18n("design/ezwebin/full/event_view_program")} &rarr;</a></li>
            {/if}
        {/if}
        </ul>
    
        {foreach $events as $event}
        <div class="row list">
            <div class="col-xs-2">
                {if $daymode}
                    <h2>{$event.object.data_map.from_time.content.timestamp|datetime(custom,"%j %M")}</h2>
                {else}
                    <h2>{$event.object.data_map.from_time.content.timestamp|datetime(custom,"%M<br />%y")}</h2>
                {/if}
            </div>
            <div class="col-xs-10">
                <h4><a href={$event.url_alias|ezurl}>{$event.name|wash}</a></h4>
                <p>
                    <span class="ezagenda_date">
                    {$event.object.data_map.from_time.content.timestamp|datetime(custom,"%H:%i")}
                    {if $event.object.data_map.to_time.has_content}
                        {if $event.object.data_map.to_time.content.day|int()|eq( $event.object.data_map.from_time.content.day|int() )}
                        - {$event.object.data_map.to_time.content.timestamp|datetime(custom,"%H:%i")}
                        {else}
                        - {$event.object.data_map.to_time.content.timestamp|datetime(custom,"%j %M %H:%i")}
                        {/if}
                    {/if}
                    </span>
                    {if $event.object.data_map.category.has_content}
                        <span class="ezagenda_keyword">
                        {attribute_view_gui attribute=$event.object.data_map.category}
                        </span>
                    {/if}
                </p>

                {if $event.object.data_map.text.has_content}
                    <div class="attribute-short">{attribute_view_gui attribute=$event.object.data_map.text}</div>
                {/if}
            </div>
        </div>
        {/foreach}
        
        <ul class="pager">
        {if $direction}                
            {if $older_event_count|gt(0)}
                <li class="previous"><a href={concat("/content/view/full/",  $node.node_id, "/offset/-", $temp_offset|sum(2))|ezurl}>&larr; {"Past events"|i18n("design/ezwebin/full/event_view_program")}</a></li>
            {/if}
                    
            {if $temp_offset|gt(0)}
                <li class="next"><a href={concat("/content/view/full/",  $node.node_id, "/offset/-", $temp_offset)|ezurl}>{"Future events"|i18n("design/ezwebin/full/event_view_program")} &rarr;</a></li>
            {elseif $newer_event_count|gt(0)}
                <li class="next"><a href={concat("/content/view/full/",  $node.node_id, "/offset/0")|ezurl}>{"Future events"|i18n("design/ezwebin/full/event_view_program")} &rarr;</a></li>
            {/if}
        {else}
            {if $temp_offset|gt(0)}
                <li class="previous"><a href={concat("/content/view/full/",  $node.node_id, "/offset/", $temp_offset|dec)|ezurl}>&larr; {"Past events"|i18n("design/ezwebin/full/event_view_program")}</a></li>
            {elseif $older_event_count|gt(0)}
                <li class="previous"><a href={concat("/content/view/full/",  $node.node_id, "/offset/-1")|ezurl}>&larr; {"Past events"|i18n("design/ezwebin/full/event_view_program")}</a></li>
            {/if}
            {if $newer_event_count|gt(0)}
                <li class="next"><a href={concat("/content/view/full/",  $node.node_id, "/offset/", $temp_offset|inc)|ezurl}>{"Future events"|i18n("design/ezwebin/full/event_view_program")} &rarr;</a></li>
            {/if}
        {/if}
        </ul>

{undef}
    </div>
</div>