{def $valid_node = $block.valid_nodes[0]}

{if $valid_node|not()}
    {set $valid_node = ezini( 'NodeSettings', 'RootNode', 'content.ini' )}
{/if}

<div class="block-type-lista block-{$block.view} block-lista_tab">

	{if $block.name}
		<h2 class="block-title">{$block.name}</h2>
	{else}
		<h2 class="block-title">{$valid_node.name|wash()}</h2>
	{/if}

{def

    $event_node    = $valid_node
    $event_node_id = $valid_node.node_id

    $curr_ts = currentdate()
    $curr_today = $curr_ts|datetime( custom, '%j')
    $curr_year = $curr_ts|datetime( custom, '%Y')
    $curr_month = $curr_ts|datetime( custom, '%n')
    
    $curr_first = makedate($curr_month, $curr_today, $curr_year)
    $curr_last = makedate($curr_month, sum( $curr_today, 1 ), $curr_year)|sub(1)

    $temp_ts = currentdate()
    $days = $temp_ts|datetime( custom, '%t')
    $static_days = 60|mul( 86400 )

    $temp_month = $temp_ts|datetime( custom, '%n')
    $temp_year = $temp_ts|datetime( custom, '%Y')
    $temp_today = $temp_ts|datetime( custom, '%j')
    
    $first_ts = makedate($temp_month, 1, $temp_year)
    $dayone = $first_ts|datetime( custom, '%w' )
    
    $last_ts = sum( $curr_first, $static_days )
    
    $ezfind_month_first = $first_ts|datetime( 'custom', '%Y-%m-%dT%H:%i:%sZ' )
    $ezfind_month_last = $last_ts|datetime( 'custom', '%Y-%m-%dT%H:%i:%sZ' )
    $ezfind_curr_first = $curr_first|datetime( 'custom', '%Y-%m-%dT%H:%i:%sZ' )
    $ezfind_curr_last = $curr_last|datetime( 'custom', '%Y-%m-%dT%H:%i:%sZ' )
    
    $filters_parameters = getFilterParameters()
    
    $prox_search_hash = hash( 
                        'limit', 100,
                        'subtree_array', array( $event_node_id ),
                        'sort_by', hash( solr_field('from_time','date'), 'asc' ),
                        'filter', array(
                            'or',
                                concat( solr_field('from_time','date'),':[', $ezfind_curr_first, ' TO ', $ezfind_month_last, ']' )
                            )
                       )
    $search_hash = hash( 
                        'limit', 100,
                        'subtree_array', array( $event_node_id ),
                        'sort_by', hash( solr_field('from_time','date'), 'desc' ),
                        'filter', array(
                            'or',
                                concat( solr_field('from_time','date'),':[', $ezfind_curr_first, ' TO ', $ezfind_curr_last, ']' ),
                                concat( solr_field('to_time','date'),':[', $ezfind_curr_first, ' TO ', $ezfind_curr_last, ']' ),
                                array( 'and',
                                    concat( solr_field('from_time','date'),':[* TO ', $ezfind_curr_first, ']' ),
                                    concat( solr_field('top_time','date'),':[', $ezfind_curr_last, ' TO *]' )
                                )
                            )
                       )
    $prox_search = fetch( ezfind, search, $prox_search_hash )
    $search = fetch( ezfind, search, $search_hash )
    
    $events = $search['SearchResult']
    $events_count  = $search['SearchCount']
    $prossimi = $prox_search['SearchResult']
    $prossimi_count = $prox_search['SearchCount']
    $day_array = " "
    $loop_dayone = 1
    $loop_daylast = 1
    $day_events = array()
}

{foreach $events as $event}
    {if eq($temp_month|int(), $event.data_map.from_time.content.month|int())}
        {set $loop_dayone = $event.data_map.from_time.content.day}
    {else}
        {set $loop_dayone = 1}
    {/if}
    {if $event.data_map.to_time.content.is_valid}
       {if eq($temp_month|int(), $event.data_map.to_time.content.month|int())}
            {set $loop_daylast = $event.data_map.to_time.content.day}
        {else}
            {set $loop_daylast = $days}
        {/if}
    {else}
         {set $loop_daylast = $loop_dayone}
    {/if}
    {for $loop_dayone|int() to $loop_daylast|int() as $counter}
        {set $day_array = concat($day_array, $counter, ', ')}
        {if eq($counter,$temp_today)}
            {set $day_events = $day_events|append( $event )}
        {/if}
    {/for}
{/foreach}

{def $day_events_count = count( $day_events )}
     
    {if and( $prossimi_count|eq(0), $day_events_count|eq(0) )}
    
        <div class="warning"><p>Nessun evento in programma</p></div>
    
    {else}
    
    <div  class="ui-tabs">		
	
		<div class="border-box box-trans-blue box-tabs-header tabs">
		<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
		<div class="border-ml"><div class="border-mr"><div class="border-mc">
		<div class="border-content" id="zone-id-{$block.id}">
			<ul class="ui-tabs-nav">							 

				{if $day_events_count|ne(0)}
                <li class="ui-state-active eventi-oggi">
					<a href="#oggi"><span class="oggi">Oggi</span></a>
				</li>
                {/if}

                {if $prossimi_count|gt(0)}
				<li class="{if $day_events_count|ne(0)}ui-state-default{else}ui-state-active{/if} eventi-prossimamente">
					<a href={concat($valid_node.url_alias, '/(show)/prossimamente/')|ezurl()} 
					   title="{$valid_node.name|wash()}"><span class="prossimamente">Prossimamente</span></a>
				</li>
                {/if}
				
			</ul>
		</div>
		</div></div></div>
		</div>	


		<div class="tabs-panels">
            
            {if $day_events_count|ne(0)}
			<div id="oggi" class="ui-tabs-hide">
				
				<div class="border-box box-violet box-tabs-panel">
				<div class="border-ml"><div class="border-mr"><div class="border-mc">
				<div class="border-content">
					{if $day_events_count}
					<ul class="eventi-cycle">								
						{foreach $day_events as $index => $child}
							<li class="evento-cycle {if $day_events_count|eq($index|inc())}lastli{/if}{if $index|eq(2)} no-js-lastli{/if}{if $index|ge(3)} no-js-hide{/if}">												
							{node_view_gui content_node=$child view='event'}
							</li>
						{/foreach}
					</ul>
					{/if}
				</div>
				</div></div></div>
				</div>
				
				<div class="border-box box-violet-gray box-tabs-footer tab-link">
				<div class="border-ml"><div class="border-mr"><div class="border-mc">
				<div class="border-content">				
					<a class="calendar arrows" href={$valid_node.url_alias|ezurl()} title="{$valid_node.name|wash()}"><span class="arrows-blue-r">Vedi tutto il calendario</span></a>			
				</div>
				</div></div></div>
				<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
				</div>
				
			</div>
            {/if}

			{if $prossimi_count|gt(0)}
			<div id="prossimamente" class="no-js-hide ui-tabs-hide">
				
				<div class="border-box box-violet box-tabs-panel">
				<div class="border-ml"><div class="border-mr"><div class="border-mc">				
				<div class="border-content">					
					{if $prossimi_count}
					<ul class="eventi-cycle">						
						{foreach $prossimi as $index => $child}
							<li class="evento-cycle {if $prossimi_count|eq($index|inc())}lastli{/if}{if $index|eq(2)} no-js-lastli{/if}{if $index|ge(3)} no-js-hide{/if}">	
							{node_view_gui content_node=$child view='event'}
							</li>
						{/foreach}
					</ul>
					{/if}
				</div>
				</div></div></div>
				</div>
				
				<div class="border-box box-violet-gray box-tabs-footer tab-link">
				<div class="border-ml"><div class="border-mr"><div class="border-mc">
				<div class="border-content">					
					<a class="calendar arrows" href={$valid_node.url_alias|ezurl()} title="{$valid_node.name|wash()}"><span class="arrows-blue-r">Vedi tutto il calendario</span></a>		
				</div>
				</div></div></div>
				<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
				</div>
				
			</div>
            {/if}
            
		</div>

	</div>
        
    {/if}
    
</div>