The following new planning applications have been found near {$alert_address}:

{foreach name="applications" from="$applications" item="application"}
{$application->address|upper} ({$application->council_reference|upper})

{$application->description}

MORE INFORMATION: {$application->info_tinyurl}
MAP: {$application->map_url}
WHAT DO YOU THINK?: {$application->comment_tinyurl}

=============================

{/foreach}

------------------------------------------------------------

PlanningAlerts.org.au is a free service run by the charity OpenAustralia Foundation.

You can subscribe to a geoRSS feed of applications for {$alert_address} here: {$georss_url}

GeoRSS can be used to display planning applications on a map. For example, on Google Maps: http://maps.google.com.au/maps?q={$georss_url|urlencode}

To stop receiving these emails click here: {$base_url}/unsubscribe.php?cid={$confirm_id}
