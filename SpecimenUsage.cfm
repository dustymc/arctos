<cfinclude template = "includes/_header.cfm">

<cfif #action# is "nothing">
	<cfset title = "Search for Results">
	<cfquery name="ctColl" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		select collection,collection_id from collection order by collection_id
	</cfquery>
	<span class="infoLink pageHelp" onclick="pageHelp('resultsearch');">Page Help</span>
	<h2>Publication / Project Search</h2>
	<form action="SpecimenUsage.cfm" method="post">
		<input name="action" type="hidden" value="search">
		<table width="75%">
			<tr valign="top">
				<cfif isdefined("session.roles") and listfindnocase(session.roles,"coldfusion_user")>
					<td>
						<ul>
							<li>
								<a href="/Project.cfm?action=makeNew">New Project</a>
							</li>
							<li>
								<a href="/Publication.cfm?action=newBook">New Book</a>
							</li>
							<li>
								<a href="/Publication.cfm?action=newJournal">New Journal</a>
							</li>
							<li>
								<a href="/Publication.cfm?action=newJournalArt">New Journal Article</a>
							</li>
							<li>
								<a href="/Publication.cfm">Edit Journal</a>
							</li>
						</ul>
					</td>
				</cfif>
				<td>
					<h4>Projects and Publication</h4>
					<label for="p_title">Title</label>
					<input name="p_title" id="p_title" type="text">
					<label for="author">Participant</label>
					<input name="author" id="author" type="text">
					<label for="year">Year</label>
					<input name="year" id="year" type="text">
				</td>
				<td>
					<h4>Project</h4>
					
					<label for="sponsor">Project Sponsor</label>
					<input name="sponsor" id="sponsor" type="text">
				</td>
				<td>
					<h4>Publication</h4>
					<label for="journal">Journal Name</label>
					<input name="journal" id="journal" type="text">
					<label for="collection_id">Cites Collection</label>
					<cfoutput>
						<select name="collection_id" id="collection_id" size="1">
							<option value="">All</option>
							<cfloop query="ctColl">
								<option value="#collection_id#">#collection#</option>
							</cfloop>
						</select>
					</cfoutput>					
					<label for="onlyCitePubs">
						<span class="likeLink" onclick="getHelp('onlyCited');">Cite specimens only?</span>
					</label>
					<input type="checkbox" name="onlyCitePubs" id="onlyCitePubs" value="1">
					<label for="onlyCitePubs">
						<span class="likeLink" onclick="getHelp('cited_sci_name');">Cited Scientific Name</span>
					</label>
					<input name="cited_sci_Name" id="cited_sci_Name" type="text">
					<label for="onlyCitePubs">
						<span class="likeLink" onclick="getHelp('accepted_sci_name');">Accepted Scientific Name</span>
					</label>
					<input name="current_sci_Name" id="current_sci_Name" type="text">
				</td>
			</tr>
			<tr>
				<td colspan="99" align="center">
					<input type="submit" 
						value="Search" 
						class="schBtn">
					<input type="reset" 
						value="Clear Form" 
						class="clrBtn">
				</td>
			</tr>
		</table>
	</form>
</cfif>
<!-------------------------------------------------------------------------------------->
<cfif #action# is "search">
<cfoutput>
	<cfset title = "Usage Search Results">
	<cfset i=1>
	<table border width="90%"><tr><td width="50%" valign="top">
		<cfset sel = "
				SELECT 
					project.project_id,
					project.project_name,
					project.start_date,
					project.end_date,
					agent_name.agent_name,
					project_agent_role,
					agent_position,
					ACKNOWLEDGEMENT,
					s_name.agent_name sponsor_name">
		<cfset frm="
				FROM 
					project,
					project_agent,
					agent_name,
					project_sponsor,
					agent_name s_name">
		<cfset whr="
				WHERE 
					project.project_id = project_agent.project_id (+) AND
					project.project_id = project_sponsor.project_id (+) AND
					project_sponsor.agent_name_id = s_name.agent_name_id (+) AND	
					project_agent.agent_name_id = agent_name.agent_name_id (+)">
					
					
		<cfset go="no">		
		<cfif isdefined("p_title") AND len(#p_title#) gt 0>
			<cfset go="yes">
			<cfset whr = "#whr# AND upper(project.project_name) like '%#ucase(escapeQuotes(p_title))#%'">
		</cfif>
		<cfif isdefined("author") AND len(#author#) gt 0>
			<cfset go="yes">
			<cfset whr = "#whr# AND project.project_id IN 
				( select project_id FROM project_agent
					WHERE agent_name_id IN 
						( select agent_name_id FROM agent_name WHERE 
						upper(agent_name) like '%#ucase(author)#%' ))">
				
		</cfif>
		<cfif isdefined("sponsor") AND len(#sponsor#) gt 0>
			<cfset go="yes">
			<cfset whr = "#whr# AND project.project_id IN 
				( select project_id FROM project_sponsor
					WHERE agent_name_id IN 
						( select agent_name_id FROM agent_name WHERE 
						upper(agent_name) like '%#ucase(sponsor)#%' ))">
				
		</cfif>
		<cfif isdefined("year") AND isnumeric(#year#)>
			<cfset go="yes">
			<cfset whr = "#whr# AND (
				#year# between to_number(to_char(start_date,'YYYY')) AND to_number(to_char(end_date,'YYYY'))
				)">
		</cfif>
		
		<cfif go is "no">
			<cfset whr = "#whr# and 1=2">
		</cfif>
		<cfset sql = "#sel# #frm# #whr# ORDER BY project_name">
		<cftry>
			<cfquery name="projects" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
				#preservesinglequotes(sql)#
			</cfquery>
			<cfcatch>
				<cfset sql=cfcatch.sql>
				<cfset message=cfcatch.message>
				<cfset queryError=cfcatch.queryError>
				<cf_queryError>
			</cfcatch>
		</cftry>
		<cfquery name="projNames" dbtype="query">
			SELECT 
				project_id,
				project_name,
				start_date,
				end_date
			FROM
				projects
			GROUP BY
				project_id,
				project_name,
				start_date,
				end_date
			ORDER BY
				project_name
		</cfquery>
		<h3>Projects</h3>
		<cfif projNames.recordcount is 0>
			<div class="notFound">
				No projects matched your criteria.
			</div>
		</cfif>
		<cfloop query="projNames">
			<cfquery name="thisAuth" dbtype="query">
				SELECT 
					agent_name, 
					project_agent_role 
				FROM 
					projects 
				WHERE 
					project_id = #project_id# 
				GROUP BY 
					agent_name, 
					project_agent_role 
				ORDER BY 
					agent_position
			</cfquery>
			<cfquery name="thisSponsor" dbtype="query">
				SELECT 
					ACKNOWLEDGEMENT,
					sponsor_name
				FROM 
					projects 
				WHERE 
					project_id = #project_id# and
					sponsor_name is not null
				GROUP BY 
					ACKNOWLEDGEMENT,
					sponsor_name
				ORDER BY 
					sponsor_name
			</cfquery>
			<div #iif(i MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#>
				<a href="/ProjectDetail.cfm?project_id=#project_id#">
					<div class="indent">
					#project_name#
					</div>
				</a>
				<cfloop query="thisAuth">
					#agent_name# (#project_agent_role#)<br>
				</cfloop>
				<cfloop query="thisSponsor">
					Sponsored by #sponsor_name#: #ACKNOWLEDGEMENT#<br>
				</cfloop>
				#dateformat(start_date,"dd mmm yyyy")# - #dateformat(end_date,"dd mmm yyyy")#
				<cfif isdefined("session.roles") and listfindnocase(session.roles,"coldfusion_user")>					
					<br><a href="/Project.cfm?Action=editProject&project_id=#project_id#">Edit</a>
				</cfif>
			</div>
			<cfset i=#i#+1>
		</cfloop>


			</td>
			<td width="50%" valign="top">

<!--- publications --->
<cfset go="no">
<cfset basSQL = "SELECT DISTINCT 
			publication.publication_id,
			publication.publication_type,
			formatted_publication,
			description,
			link ">
		<cfset basFrom = "
		FROM 
			publication,
			publication_author_name,
			project_publication,
			agent_name pubAuth,
			agent_name searchAuth,
			formatted_publication,
			publication_url">
		<cfset basWhere = "
		WHERE 
		publication.publication_id = project_publication.publication_id (+) 
		AND publication.publication_id = publication_author_name.publication_id (+) 
		AND publication.publication_id = publication_url.publication_id (+) 
		AND publication_author_name.agent_name_id = pubAuth.agent_name_id (+)
		AND pubAuth.agent_id = searchAuth.agent_id
		AND formatted_publication.publication_id (+) = publication.publication_id 
		AND formatted_publication.format_style = 'full citation'">
		
	<cfif isdefined("p_title") AND len(#p_title#) gt 0>
		<cfset basWhere = "#basWhere# AND UPPER(publication_title) LIKE '%#ucase(escapeQuotes(p_title))#%'">
		<cfset go="yes">
	</cfif>
	<cfif isdefined("collection_id") AND len(#collection_id#) gt 0>
		<cfset go="yes">
		<cfset basFrom = "#basFrom#,cataloged_item">
		<cfif #basFrom# does not contain "citation">
			<cfset basFrom = "#basFrom#,citation">
		</cfif>
		<cfset basWhere = "#basWhere# AND publication.publication_id = citation.publication_id 
			AND citation.collection_object_id = cataloged_item.collection_object_id AND
			cataloged_item.collection_id = #collection_id#">
	</cfif>
	<cfif isdefined("author") AND len(#author#) gt 0>
		<cfset go="yes">
		<cfset author = #replace(author,"'","''","all")#>
		<cfset basWhere = "#basWhere# AND UPPER(searchAuth.agent_name) LIKE '%#ucase(author)#%'">
	</cfif>
	<cfif isdefined("year") AND isnumeric(#year#)>
		<cfset go="yes">
		<cfset basWhere = "#basWhere# AND PUBLISHED_YEAR = #year#">
	</cfif>
	<cfif isdefined("journal") AND len(journal) gt 0>
		<cfset go="yes">
		<cfset basFrom = "#basFrom# ,journal,journal_article">
		<cfset basWhere = "#basWhere# AND publication.publication_id=journal_article.publication_id and
			journal_article.journal_id=journal.journal_id and
			upper(journal_name) like '%#ucase(journal)#%'">
	</cfif>
	<cfif isdefined("onlyCitePubs") AND #onlyCitePubs# gt 0>
		<cfset go="yes">
		<cfif #basFrom# does not contain "citation">
			<cfset basFrom = "#basFrom#,citation">
		</cfif>
		<cfset basWhere = "#basWhere# AND publication.publication_id = citation.publication_id">
	</cfif>
	
	<cfif isdefined("current_Sci_Name") AND len(#current_Sci_Name#) gt 0>
		<cfset go="yes">
		<cfset basFrom = "#basFrom# ,
			citation CURRENT_NAME_CITATION, 
			cataloged_item,
			identification catItemTaxa">
		<cfset basWhere = "#basWhere# AND publication.publication_id = CURRENT_NAME_CITATION.publication_id (+)
		AND CURRENT_NAME_CITATION.collection_object_id = cataloged_item.collection_object_id (+)
		AND cataloged_item.collection_object_id = catItemTaxa.collection_object_id
		AND catItemTaxa.accepted_id_fg = 1
		AND upper(catItemTaxa.scientific_name) LIKE '%#ucase(current_Sci_Name)#%'">
	</cfif>
	<cfif isdefined("cited_Sci_Name") AND len(#cited_Sci_Name#) gt 0>
		<cfset go="yes">
		<cfset basFrom = "#basFrom# ,
			citation CITED_NAME_CITATION, taxonomy CitTaxa">
			<cfset basWhere = "#basWhere# AND publication.publication_id = CITED_NAME_CITATION.publication_id (+)
				AND CITED_NAME_CITATION.cited_taxon_name_id = CitTaxa.taxon_name_id (+)
				AND upper(CitTaxa.scientific_name) LIKE '%#ucase(cited_Sci_Name)#%'">
	</cfif>
	
	<cfif go is "no">
		<cfset basWhere = "#basWhere# AND 1=2">
	</cfif>
	<cfset basSql = "#basSQL# #basFrom# #basWhere# ORDER BY formatted_publication,publication_id">
<cftry>
	<cfquery name="publication" datasource="user_login" username="#session.dbuser#" password="#decrypt(session.epw,cfid)#">
		#preservesinglequotes(basSQL)#
	</cfquery>
	<cfcatch>
		<cfset sql=cfcatch.sql>
		<cfset message=cfcatch.message>
		<cfset queryError=cfcatch.queryError>
		<cf_queryError>
	</cfcatch>
</cftry>

	<h3>
	Publications
	</h3>
	<cfif publication.recordcount is 0>
		<div class="notFound">
			No publications matched your criteria.
		</div>
	</cfif>
	<cfquery name="pubs" dbtype="query">
		SELECT
			publication_id,
			publication_type,
			formatted_publication
		FROM
			publication
		GROUP BY
			publication_id,
			publication_type,
			formatted_publication
		ORDER BY
			formatted_publication
	</cfquery>
	<cfloop query="pubs">
		
		<div #iif(i MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#>
		<p style="text-indent:-2em;padding-left:2em; ">
		#formatted_publication#
		<br><input type="button" 
					value="Details" 
					class="lnkBtn"
					onmouseover="this.className='lnkBtn btnhov'" 
					onmouseout="this.className='lnkBtn'"
					onclick="document.location='/PublicationResults.cfm?publication_id=#publication_id#';">
		<input type="button" 
					value="Cited Specimens" 
					class="lnkBtn"
					onmouseover="this.className='lnkBtn btnhov'" 
					onmouseout="this.className='lnkBtn'"
					onclick="document.location='/SpecimenResults.cfm?publication_id=#publication_id#';">
		<cfif isdefined("session.roles") and listfindnocase(session.roles,"manage_publications")>
			<cfif #publication_type# is "Book">
				<cfset thisAction = "editBook">
		 	<cfelseif #publication_type# is "Book Section">
				<cfset thisAction = "editBookSection">
		  	<cfelseif #publication_type# is "Journal Article">
				<cfset thisAction = "editJournalArt">	
			</cfif>
			<input type="button" 
					value="Edit" 
					class="lnkBtn"
					onmouseover="this.className='lnkBtn btnhov'" 
					onmouseout="this.className='lnkBtn'"
					onclick="document.location='/Publication.cfm?Action=#thisAction#&publication_id=#publication_id#';">
			<input type="button" 
					value="Citations" 
					class="lnkBtn"
					onmouseover="this.className='lnkBtn btnhov'" 
					onmouseout="this.className='lnkBtn'"
					onclick="document.location='/Citation.cfm?publication_id=#publication_id#';">
		</cfif>
		</p>
		<cfquery name="links" dbtype="query">
			select description,
			link from publication
			where publication_id=#publication_id#
		</cfquery>
		<cfif len(#links.description#) gt 0>
			<ul>
				<cfloop query="links">
					<li><a href="#link#" target="_blank">#description#</a></li>
				</cfloop>
			</ul>
		</cfif>
			
		</div>
	<cfset i=#i#+1>
	</cfloop>

		</td>
	</tr>
	</table>



	<cf_getSearchTerms>
	<cfset log.query_string=returnURL>
	<cfset log.reported_count=0>
	<cfif isdefined("pubs.RecordCount")>
		<cfset log.reported_count=log.reported_count+pubs.RecordCount>
	</cfif>
	<cfif isdefined("projNames.RecordCount")>
		<cfset log.reported_count=log.reported_count+projNames.RecordCount>
	</cfif>
	<cfinclude template="/includes/activityLog.cfm">
</cfoutput>
</cfif>
<!-------------------------------------------------------------------------------------->
<cfinclude template = "/includes/_footer.cfm">