
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
<link rel="stylesheet" href="http://cdn.datatables.net/1.10.2/css/jquery.dataTables.min.css">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript"  src="http://cdn.datatables.net/1.10.2/js/jquery.dataTables.min.js"></script>
<script type="text/javascript"  src="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js">
</script>


<script>

$.fn.dataTable.ext.type.detect.unshift(
    function ( d ) {
	return d === 'LOW' || d === 'MEDIUM' || d === 'HIGH' || d === 'CRITICAL' || d === 'UNKNOWN' ?
	    'severity-grade' :
	    null;
    }
);
 
$.fn.dataTable.ext.type.order['severity-grade-pre'] = function ( d ) {
    switch ( d ) {
    	case 'UNKNOWN': return 1;
    	case 'LOW':	return 2;
	case 'MEDIUM':    return 3;
	case 'HIGH': return 4;
	case 'CRITICAL':   return 5;
    }
    return 0;
};
 
 
$(document).ready(function() {
    $('#myTable').DataTable();
} );
</script>


{{- if . }}
    <style>   
      * {
        font-family: Courier New, monospace;
      }
      h1 {
        text-align: center;
      }
      .group-header th {
        font-size: 100%;
      }
      .sub-header th {
        font-size: 70%;
      }
      .severity-LOW .severity {  background-color: #FFFF00; }
      .severity-MEDIUM .severity {  background-color: #FF8C00; }
      .severity-HIGH .severity {  background-color: #FF6347; }
      .severity-CRITICAL .severity {  background-color: #FF0000; }
      .severity-UNKNOWN .severity {  background-color: #747474; }
      .severity-LOW {  background-color: #FFFFFF; }
      .severity-MEDIUM {  background-color: #FFFFFF;}
      .severity-HIGH {  background-color: #FFFFFF; }
      .severity-CRITICAL {  background-color: #FFFFFF; }
      .severity-UNKNOWN { background-color: #FFFFFF; }
      table tr td:first-of-type {
        font-weight: 200;
      }
      table, th, td {
        border: 2px groove purple;
        border-collapse: collapse;
        white-space: nowrap;
        padding: .3em;
      }
      table {
        margin: 0 auto;
      }
      .severity {
        text-align: center;
        font-weight: bold;
        color: black;
      }

      .links a,
      .links[data-more-links=on] a {
        display: block;
     }
      .links[data-more-links=off] a:nth-of-type(1n+5) {
        display: none;
      }
      a.toggle-more-links { cursor: pointer; }
    </style>
    <title>{{- escapeXML ( index . 0 ).Target }} - Trivy Test Report - {{ getCurrentTime }}</title>
  </head>
  <body>
    <h1>{{- escapeXML ( index . 0 ).Target }} - Trivy Report - {{ getCurrentTime }}</h1>
    <div class="table-responsive">
    <table id="myTable" width=100%>
    <thead>
    {{- range . }}
      <tr class="group-header"><th colspan="6">{{ escapeXML .Type }}</th></tr>
      {{- if (eq (len .Vulnerabilities) 0) }}
      <tr><th colspan="6">No Vulnerabilities found</th></tr>
      {{- else }}
      <tr class="sub-header">
        <th>Package</th>
        <th>Vulnerability ID</th>
        <th>Severity</th>
        <th>Installed Version</th>
        <th>Fixed Version</th>
        <th>Links</th>
      </tr>
     </thead>
     <tbody>
        {{- range .Vulnerabilities }}
      <tr class="severity-{{ escapeXML .Vulnerability.Severity }}">
        <td class="pkg-name">{{ escapeXML .PkgName }}</td>
        <td><a href="https://nvd.nist.gov/vuln/detail/{{ escapeXML .VulnerabilityID }}" target="_blank">{{ escapeXML .VulnerabilityID }}</a></td>
        <td class="severity">{{ escapeXML .Vulnerability.Severity }}</td>
        <td class="pkg-version">{{ escapeXML .InstalledVersion }}</td>
        <td>{{ escapeXML .FixedVersion }}</td>
        <td class="links" data-more-links="off">
          {{- range .Vulnerability.References }}
          <a href={{ escapeXML . | printf "%q" }}>{{ escapeXML . }}</a>
          {{- end }}
        </td>
      </tr>
        {{- end }}
      {{- end }}
    {{- end }}
    </tbody>
    </table>
    </div>
{{- else }}
  </head>
  <body>
    <h1>Trivy Returned Empty Report</h1>
{{- end }}
  </body>
</html>




