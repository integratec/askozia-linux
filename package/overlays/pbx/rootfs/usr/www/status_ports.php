#!/usr/bin/php
<?php 
/*
	$Id$
	part of m0n0wall (http://m0n0.ch/wall)
	
	Copyright (C) 2003-2006 Manuel Kasper <mk@neon1.net>.
	All rights reserved.
	
	Redistribution and use in source and binary forms, with or without
	modification, are permitted provided that the following conditions are met:
	
	1. Redistributions of source code must retain the above copyright notice,
	   this list of conditions and the following disclaimer.
	
	2. Redistributions in binary form must reproduce the above copyright
	   notice, this list of conditions and the following disclaimer in the
	   documentation and/or other materials provided with the distribution.
	
	THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
	INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
	AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
	AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
	OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
	SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
	INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
	CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
	POSSIBILITY OF SUCH DAMAGE.
*/

require("guiconfig.inc");

$pgtitle = array(gettext("Status"), gettext("Ports"));

$ports = dahdi_get_physical_ports();
foreach ($ports as $port) {
	if ($port['technology'] == "analog") {
		$analog_ports[] = $port;
	} else if ($port['technology'] == "isdn") {
		$isdn_ports[] = $port;
	}
}

include("fbegin.inc");

?><table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td colspan="2" class="listtopic"><?=gettext('Network');?></td>
	</tr>
	<tr> 
		<td width="20%" class="vncellreq" valign="top">&nbsp;</td>
		<td width="80%" class="listr"><pre><?
			exec("/sbin/ifconfig", $output);
			$output = implode("\n", $output);
			echo htmlspecialchars($output);
		?></pre></td>
	</tr>
	<tr>
		<td colspan="2" class="list" height="12"></td>
	</tr><?

	if ($isdn_ports) {
		?><tr>
			<td colspan="2" class="listtopic"><?=gettext('ISDN');?></td>
		</tr>
		<tr>
			<td width="20%" class="vncellreq" valign="top">&nbsp;</td>
			<td width="80%" class="listr"><?=print_r_html($isdn_ports);?></td>
		</tr>
		<tr>
			<td colspan="2" class="list" height="12"></td>
		</tr><?
	}

	if ($analog_ports) {
		?><tr>
			<td colspan="2" class="listtopic"><?=gettext('Analog');?></td>
		</tr>
		<tr>
			<td width="20%" class="vncellreq" valign="top">&nbsp;</td>
			<td width="80%" class="listr"><?=print_r_html($analog_ports);?></td>
		</tr>
		<tr>
			<td colspan="2" class="list" height="12"></td>
		</tr><?
	}

?></table><?

include("fend.inc");
