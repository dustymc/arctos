 <cfinclude template="includes/_header.cfm">
<cfif not isdefined("project_id")>
	<cfset project_id = -1>
</cfif>
<cfquery name="ctLoanType" datasource="#Application.web_user#">
	select loan_type from ctloan_type order by loan_type
</cfquery>
<cfquery name="ctLoanStatus" datasource="#Application.web_user#">
	select loan_status from ctloan_status order by loan_status
</cfquery>
<cfquery name="ctcoll" datasource="#Application.web_user#">
	select collection_cde from ctcollection_cde order by collection_cde
</cfquery>
<cfquery name="ctInst" datasource="#Application.web_user#">
	select distinct(institution_acronym)  from collection order by institution_acronym
</cfquery>
<cfquery name="cttrans_agent_role" datasource="#Application.web_user#">
	select distinct(trans_agent_role)  from cttrans_agent_role order by trans_agent_role
</cfquery>
<script>
	function setAccnNum(i,v) {
		var e = document.getElementById('loan_number');
		e.value=v;
		var inst = document.getElementById('institution_acronym');
		inst.value=i;	
	}
</script>
<!-------------------------------------------------------------------------------------------------->
<cfif #action# is "nothing">
<cfset title="Manage Loans">
<cfoutput>
<form action="Loan.cfm" method="post">
		<input type="hidden" name="action" value="newLoan">
		 <input type="submit" value="Create a new loan" class="insBtn"
   onmouseover="this.className='insBtn btnhov'" onmouseout="this.className='insBtn'">	

	</form>
	<form action="Loan.cfm" method="post">
		<input type="hidden" name="action" value="addItems">
		<input type="submit" value="Manage an existing loan" class="schBtn"
   onmouseover="this.className='schBtn btnhov'" onmouseout="this.className='schBtn'">	
		
	</form>
			<cfif isdefined("client.roles") and listfindnocase(client.roles,"coldfusion_user")>					
		<form action="/loanBulkload.cfm" method="post">
		<input type="submit" value="Bulk Add Loan Items" class="insBtn"
   onmouseover="this.className='insBtn btnhov'" onmouseout="this.className='insBtn'">	
		
	</form>
	</cfif>
</cfoutput>
</cfif>
<!-------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------->
<cfif  #action# is "newLoan">
<cfset title="New Loan">
	Initiate a loan: <span class="infoLink" onClick="getDocs('loan')">Help</span>

	
	<cfoutput>
		<form name="newloan" action="Loan.cfm" method="post" onSubmit="return noenter();">
			<input type="hidden" name="action" value="makeLoan">
			<!--- set loan_number - same code works for accn_num --->
<table border>
	<tr>
		<td>
			<label for="institution_acronym">Institution
			</label>
			<select name="institution_acronym" size="1" id="institution_acronym">
				<cfloop query="ctInst">
					<option value="#ctInst.institution_acronym#">#ctInst.institution_acronym#</option>
				</cfloop>
			</select>
		</td>
		<td>
			<label for="loan_number">Loan Number</label>
			<input type="text" name="loan_number" class="reqdClr" id="loan_number">
		</td>
		<td rowspan="99" valign="top">
			Next Available Loan Number:
			<br>
			
			<cfif #cgi.HTTP_HOST# contains "database.museum">
				<ul>
					<li>
						<cfquery name="uam_mamm" datasource="#Application.web_user#">
							select lpad(max(to_number(substr(loan_number,6,3))) + 1,3,0) nn from loan,trans where
							loan.transaction_id = trans.transaction_id and
							substr(loan_number,1,4)='#dateformat(now(),"yyyy")#' and
							institution_acronym='UAM' and
							substr(loan_number,10,4)='Mamm'
						</cfquery>
						<cfif #uam_mamm.recordcount# is 0>
							<!--- new year, prolly --->
							<cfset thisNum = '#dateformat(now(),"yyyy")#.001.Mamm'>
						<cfelse>
							<cfset thisNum = '#dateformat(now(),"yyyy")#.#uam_mamm.nn#.Mamm'>
						</cfif>
						<span class="likeLink" onclick="setAccnNum('UAM','#thisNum#')">UAM #thisNum#</span>
					</li>
					<li>
						<cfquery name="msb_mamm" datasource="#Application.web_user#">
							select max(to_number(substr(loan_number,
							(instr(loan_number,'.',1,1)+1),
							(instr(loan_number,'.',1,2) - instr(loan_number,'.',1,1) - 1)))) + 1 nn from loan,trans where
							loan.transaction_id = trans.transaction_id and
							substr(loan_number,1,4)='#dateformat(now(),"yyyy")#' and
							institution_acronym='MSB' and
							substr(loan_number,10,4)='Mamm'
						</cfquery>
						<cfif #msb_mamm.recordcount# is 0>
							<!--- new year, prolly --->
							<cfset thisNum = '#dateformat(now(),"yyyy")#.1.Mamm'>
						<cfelse>
							<cfset thisNum = '#dateformat(now(),"yyyy")#.#msb_mamm.nn#.Mamm'>
						</cfif>
						<span class="likeLink" onclick="setAccnNum('MSB','#thisNum#')">MSB #thisNum#</span>
					</li>
					<li>
						<cfquery name="dgr_mamm" datasource="#Application.web_user#">
							select max(to_number(substr(loan_number,
							(instr(loan_number,'.',1,1)+1),
							(instr(loan_number,'.',1,2) - instr(loan_number,'.',1,1) - 1)))) + 1 nn from loan,trans where
							loan.transaction_id = trans.transaction_id and
							substr(loan_number,1,4)='#dateformat(now(),"yyyy")#' and
							institution_acronym='DGR' and
							substr(loan_number,10,4)='Mamm'
						</cfquery>
						<cfif #dgr_mamm.recordcount# is 0>
							<!--- new year, prolly --->
							<cfset thisNum = '#dateformat(now(),"yyyy")#.1.Mamm'>
						<cfelse>
							<cfset thisNum = '#dateformat(now(),"yyyy")#.#dgr_mamm.nn#.Mamm'>
						</cfif>
						<span class="likeLink" onclick="setAccnNum('DGR','#thisNum#')">DGR #thisNum#</span>
					</li>
					<li>
						<cfquery name="dgr_bird" datasource="#Application.web_user#">
							select max(to_number(substr(loan_number,
							(instr(loan_number,'.',1,1)+1),
							(instr(loan_number,'.',1,2) - instr(loan_number,'.',1,1) - 1)))) + 1 nn from loan,trans where
							loan.transaction_id = trans.transaction_id and
							substr(loan_number,1,4)='#dateformat(now(),"yyyy")#' and
							institution_acronym='DGR' and
							substr(loan_number,10,4)='Bird'
						</cfquery>
						<cfif #dgr_bird.recordcount# is 0>
							<!--- new year, prolly --->
							<cfset thisNum = '#dateformat(now(),"yyyy")#.1.Bird'>
						<cfelse>
							<cfset thisNum = '#dateformat(now(),"yyyy")#.#dgr_bird.nn#.Bird'>
						</cfif>
						<span class="likeLink" onclick="setAccnNum('DGR','#thisNum#')">DGR #thisNum#</span>
					</li>
				</ul>
				<span class="likeLink" onclick="setAccnNum('#dgr_bird.nn#')">#dgr_bird.nn#</span>
			<cfelseif #cgi.HTTP_HOST# contains "berkeley.edu">
				<!--- all collection share loan number and never start over --->
				<cfquery name="mvz_mamm" datasource="#Application.web_user#">
					select 
						max(to_number(substr(loan_number,
							(instr(loan_number,'.',1,1)+1),
							(instr(loan_number,'.',1,2) - instr(loan_number,'.',1,1) - 1)))) + 1 nn 
					from loan,trans where
					loan.transaction_id = trans.transaction_id
				</cfquery>
				<ul>
					<li>
						<cfset thisNum = '#dateformat(now(),"yyyy")#.#mvz_mamm.nn#.Bird'>
						<span class="likeLink" onclick="setAccnNum('MVZ','#thisNum#')">MVZ #thisNum#</span>
					</li>
					<li>
						<cfset thisNum = '#dateformat(now(),"yyyy")#.#mvz_mamm.nn#.Herp'>
						<span class="likeLink" onclick="setAccnNum('MVZ','#thisNum#')">MVZ #thisNum#</span>
					</li>
					<li>
						<cfset thisNum = '#dateformat(now(),"yyyy")#.#mvz_mamm.nn#.Mamm'>
						<span class="likeLink" onclick="setAccnNum('MVZ','#thisNum#')">MVZ #thisNum#</span>
					</li>
				</ul>
			</cfif>
		</td>
	</tr>
	<tr>
		<td>
			<label for="auth_agent_name">Authorized By</label>
			<input type="text" name="auth_agent_name" class="reqdClr" size="40" 
			  onchange="getAgent('auth_agent_id','auth_agent_name','newloan',this.value); return false;"
			  onKeyPress="return noenter(event);"> 
			<input type="hidden" name="auth_agent_id">
		</td>
		<td>
			<label for="rec_agent_name"><a href="javascript:void(0);" onClick="getDocs('loan','to')">To:</a></label>
			<input type="text" name="rec_agent_name" class="reqdClr" size="40" 
			  onchange="getAgent('rec_agent_id','rec_agent_name','newloan',this.value); return false;"
			  onKeyPress="return noenter(event);"> 			  
			<input type="hidden" name="rec_agent_id">
		</td>
	</tr>
	<tr>
		<td>
			<label for="in_house_contact_agent_name">In-House Contact:</label>
			<input type="text" name="in_house_contact_agent_name" size="40" 
			  onchange="getAgent('in_house_contact_agent_id','in_house_contact_agent_name','newloan',this.value); return false;"
			  onKeyPress="return noenter(event);"> 
			<input type="hidden" name="in_house_contact_agent_id">
		</td>
		<td>
			<label for="outside_contact_agent_name">Outside Contact:</label>
			<input type="text" name="outside_contact_agent_name" size="40" 
			  onchange="getAgent('outside_contact_agent_id','outside_contact_agent_name','newloan',this.value); return false;"
			  onKeyPress="return noenter(event);"> 			  
			<input type="hidden" name="outside_contact_agent_id">
		</td>
	</tr>
	<tr>
		<td>
			<label for="loan_type">Loan Type</label>
			<select name="loan_type" id="loan_type" class="reqdClr">
				<cfloop query="ctLoanType">
					<option value="#ctLoanType.loan_type#">#ctLoanType.loan_type#</option>
				</cfloop>
			</select>
		</td>
		<td>
			<label for="loan_status">Loan Status</label>
			<select name="loan_status" id="loan_status" class="reqdClr">
				<cfloop query="ctLoanStatus">
					<option value="#ctLoanStatus.loan_status#">#ctLoanStatus.loan_status#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr>
		<td>
			<label for="initiating_date">Transaction Date</label>
			<input type="text" name="initiating_date" id="initiating_date" value="#dateformat(now(),"dd-mmm-yyyy")#">
		</td>
		<td>
			<label for="return_due_date">Return Due Date</label>
			<input type="text" name="return_due_date" id="return_due_date">
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<label for="nature_of_material">Nature of Material</label>
			<textarea name="nature_of_material" id="nature_of_material" rows="3" cols="80" class="reqdClr"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<label for="loan_instructions">Loan Instructions</label>
			<textarea name="loan_instructions" id="loan_instructions" rows="3" cols="80"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<label for="loan_description">Description</label>
			<textarea name="loan_description" id="loan_description" rows="3" cols="80"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2">
			<label for="trans_remarks">Remarks</label>
			<textarea name="trans_remarks" id="trans_remarks" rows="3" cols="80"></textarea>
		</td>
	</tr>
	<tr>
		<td colspan="2" align="center">
		 <input type="submit" value="Create Loan" class="insBtn"
   onmouseover="this.className='insBtn btnhov'" onmouseout="this.className='insBtn'">	

			&nbsp;
			
			   <input type="button" value="Quit" class="qutBtn"
   onmouseover="this.className='qutBtn btnhov'" onmouseout="this.className='qutBtn'"
   onClick="document.location = 'Loan.cfm'">	
   </td>
	</tr>
</table>
</form>
</cfoutput>
</cfif>
<!-------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------->
<cfif #Action# is "editLoan">
<cfset title="Edit Loan">
	<cfquery name="loanDetails" datasource="#Application.web_user#">
		select 
			trans.transaction_id,
			trans_date,
			loan_number,
			loan_type,
			loan_status,
			loan_instructions,
			loan_description,
			nature_of_material,
			trans_remarks,
			return_due_date,
			institution_acronym,
			concattransagent(trans.transaction_id,'entered by') enteredby
		 from 
			loan, 
			trans
		where 
			loan.transaction_id = trans.transaction_id AND
			trans.transaction_id = #transaction_id#
	</cfquery>
	<cfquery name="loanAgents" datasource="#Application.web_user#">
		select 
			trans_agent_id,
			trans_agent.agent_id, 
			agent_name,
			trans_agent_role
		from
			trans_agent,
			preferred_agent_name
		where
			trans_agent.agent_id = preferred_agent_name.agent_id and
			trans_agent_role != 'entered by' and
			trans_agent.transaction_id=#transaction_id#
		order by
			trans_agent_role,
			agent_name
	</cfquery>
<cfoutput query="loanDetails">
<cfform name="editloan" action="Loan.cfm" method="post">
			<input type="hidden" name="action" value="saveEdits">
			<input type="hidden" name="transaction_id" value="#transaction_id#">
<table>
	<tr>
		<td align="right"><strong>Edit Loan:</strong> </td>
		<td>
			<cfset tIA=#institution_acronym#>
			<select name="institution_acronym" size="1">
						<cfloop query="ctInst">
							<option <cfif #ctInst.institution_acronym# is #tIA#> selected </cfif>value="#ctInst.institution_acronym#">#ctInst.institution_acronym#</option>
						</cfloop>
				</select>
			
			<input type="text" name="loan_number" value="#loan_number#" class="reqdClr">
			<span style="font-size:small;">Entered by #enteredby#</span>
		</td>
			<td colspan="99" rowspan="99" valign="top">
			
			<strong>Projects associated with this loan:</strong>
			<p>
				<cfquery name="projs" datasource="#Application.web_user#">
					select project_name, project.project_id from project,
					project_trans where 
					project_trans.project_id =  project.project_id
					and transaction_id=#transaction_id#
				</cfquery>
				<cfif #projs.recordcount# gt 0>
					<cfloop query="projs">
						<a href="/Project.cfm?Action=editProject&project_id=#project_id#"><strong>#project_name#</strong></a><br>
					</cfloop>
				<cfelse>
					None
				</cfif>
			</p>
			<table class="newRec" width="100%">
				<tr>
					<td>Associate Project</td>
				</tr>
				<tr>
					<td>
							<input type="hidden" name="project_id">
							<input type="text" 
								size="50"
								name="pick_project_name" 
								class="reqdClr" 
								onchange="getProject('project_id','pick_project_name','editloan',this.value); return false;"
								onKeyPress="return noenter(event);">
						
					</td>
				</tr>
					
				
			</table>
			<hr />
			<table border="1" class="newRec">
				<tr>
					<td colspan="4">
						Create Project
					</td>
				</tr>
				<tr>
					<td align="right">
						Agent:
					</td>
					<td colspan="2">
						<input type="text" name="newAgent_name" 
							class="reqdClr" 
							onchange="findAgentName('newAgent_name_id','newAgent_name','editloan',this.value); return false;"
							onKeyPress="return noenter(event);"
							value="">
						<!--- need agent_name_id here --->
						<input type="hidden" name="newAgent_name_id" value="">
					</td>
					<cfquery name="ctProjAgRole" datasource="#Application.web_user#">
						select project_agent_role from ctproject_agent_role
					</cfquery>
					<td>
						<select name="project_agent_role" size="1" class="reqdClr">
								<cfloop query="ctProjAgRole">
								<option value="#ctProjAgRole.project_agent_role#">#ctProjAgRole.project_agent_role#
								</option>
								</cfloop>
							</select>
					</td>
				</tr>
				<tr>
					<td align="right">
						<a href="javascript:void(0);" onClick="getDocs('project','title')">Project&nbsp;Title</a>:
					</td>
					<td colspan="3">
						<textarea name="project_name" cols="50" rows="2" class="reqdClr"></textarea>
					</td>
				</tr>
				<tr>
					<td align="right"><a href="javascript:void(0);" onClick="getDocs('project','date')">Start&nbsp;Date</a> </td>
					<td><input type="text" name="start_date" value="#dateformat(trans_date,"dd-mmm-yyyy")#"></td>
					<td align="right">End Date</td>
					<td><input type="text" name="end_date"></td>
				</tr>
				<tr>
					<td align="right">
						<a href="javascript:void(0);" onClick="getDocs('project','description')">Description</a>
					</td>
					<td colspan="3"><textarea name="project_description" cols="50" rows="6">#loan_description#</textarea></td>
				</tr>
				<tr>
					<td align="right">Remarks</td>
					<td colspan="3"><textarea name="project_remarks" cols="50" rows="3">#trans_remarks#</textarea></td>
				</tr>
				<tr>
					<td align="right">
						Save as new project?
						
					</td>
					<td>
						NO <input type="radio" value="no" name="saveNewProject" checked="checked"/>
						
					</td>
					<td>
						Yes <input type="radio" value="yes" name="saveNewProject"/>
					</td>
				</tr>
			</table>
			</td>
	</tr>
	<!---
	<tr>
		<td align="right">To: </td>
		<td>
		<input type="text" name="rec_agent_name" class="reqdClr" size="50" value="#rec_agent#"
			  onchange="getAgent('rec_agent_id','rec_agent_name','editloan',this.value); return false;"
			  onKeyPress="return noenter(event);"> 
			<input type="hidden" name="rec_agent_id">
			 </td>
	</tr>
	<tr>
		<td align="right">Authorized By: </td>
		<td><input type="hidden" name="auth_agent_id">
			<input type="text" name="auth_agent_name" class="reqdClr" size="50" value="#auth_agent#"
			  onchange="getAgent('auth_agent_id','auth_agent_name','editloan',this.value); return false;"
			  onKeyPress="return noenter(event);"> 
   </td>

	</tr>
	--->
	<tr>
		<td colspan="2">
			<table border>
				<tr>
					<th>Agent Name</th>
					<th>Role</th>
					<th>Delete?</th>
				</tr>
				<cfloop query="loanAgents">
					<tr>
						<td>
							<input type="text" name="trans_agent_#trans_agent_id#" class="reqdClr" size="50" value="#agent_name#"
			  					onchange="getAgent('trans_agent_id_#trans_agent_id#','trans_agent_#trans_agent_id#','editloan',this.value); return false;"
			  					onKeyPress="return noenter(event);">
			  				<input type="hidden" name="trans_agent_id_#trans_agent_id#" value="#agent_id#">
						</td>
						<td>
							<cfset thisRole = #trans_agent_role#>
							<select name="trans_agent_role_#trans_agent_id#">
								<cfloop query="cttrans_agent_role">
									<option 
										<cfif #trans_agent_role# is #thisRole#> selected="selected"</cfif>
										value="#trans_agent_role#">#trans_agent_role#</option>
								</cfloop>
							</select>
						</td>
						<td>
							<input type="checkbox" name="del_agnt_#trans_agent_id#">
						</td>
					</tr>
				</cfloop>
					<tr class="newRec">
						<td>
							<label for="new_trans_agent">Add Agent:</label>
							<input type="text" name="new_trans_agent" id="new_trans_agent" class="reqdClr" size="50"
			  					onchange="getAgent('new_trans_agent_id','new_trans_agent','editloan',this.value); return false;"
			  					onKeyPress="return noenter(event);">
			  				<input type="hidden" name="new_trans_agent_id">
						</td>
						<td>
							<label for="new_trans_agent_role">&nbsp;</label>
							<select name="new_trans_agent_role" id="new_trans_agent_role">
								<cfloop query="cttrans_agent_role">
									<option value="#trans_agent_role#">#trans_agent_role#</option>
								</cfloop>
							</select>
						</td>
						<td>&nbsp;</td>
					</tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td align="right">Type: </td>
		<td><select name="loan_type" class="reqdClr">
					<cfloop query="ctLoanType">
						<option <cfif #ctLoanType.loan_type# is "#loanDetails.loan_type#"> selected </cfif>value="#ctLoanType.loan_type#">#ctLoanType.loan_type#</option>
					</cfloop>
				</select>
	<img src="images/nada.gif" width="60" height="1">
	Status:&nbsp;<select name="loan_status" class="reqdClr">
					<cfloop query="ctLoanStatus">
						<option <cfif #ctLoanStatus.loan_status# is "#loanDetails.loan_status#"> selected </cfif>value="#ctLoanStatus.loan_status#">#ctLoanStatus.loan_status#</option>
					</cfloop>
				</select>
	</td>
	</tr>
	<tr>
		<td align="right">Transaction Date: </td>
		<td><input type="text" name="initiating_date" value="#dateformat(trans_date,"dd-mmm-yyyy")#" class="reqdClr">
		<img src="images/nada.gif" width="60" height="1">Due Date:&nbsp;<input type="text" name="return_due_date" value="#dateformat(return_due_date,'dd mmm yyyy')#">
		</td>
	</tr>
	<tr>
		<td align="right">Nature of Material:</td>
		<td><textarea name="nature_of_material" rows="7" cols="60" class="reqdClr">#nature_of_material#</textarea></td>
	</tr>
	<tr>
		<td align="right">Description:</td>
		<td><textarea name="loan_description" rows="7" cols="60">#loan_description#</textarea></td>
	</tr>
	<tr>
		<td align="right">Instructions:</td>
		<td><textarea name="loan_instructions" rows="7" cols="60">#loan_instructions#</textarea></td>
	</tr>
	
	<tr>
		<td align="right">Remarks: </td>
		<td><textarea name="trans_remarks" rows="7" cols="60">#trans_remarks#</textarea></td>
	</tr>
	<tr>
		<td colspan="2" align="center">
		
		<input type="submit" value="Save Edits" class="savBtn"
   onmouseover="this.className='savBtn btnhov'" onmouseout="this.className='savBtn'">	
   
			&nbsp;
			 <input type="button" value="Quit" class="qutBtn"
   onmouseover="this.className='qutBtn btnhov'" onmouseout="this.className='qutBtn'"
   onClick="document.location = 'Loan.cfm?Action=addItems'">	

 <input type="button" value="Add Items" class="lnkBtn"
   onmouseover="this.className='lnkBtn btnhov'" onmouseout="this.className='lnkBtn'"
   onClick="window.open('SpecimenSearch.cfm?Action=dispCollObj&transaction_id=#transaction_id#','#client.target#');">
   
   <input type="button" value="Review Items" class="lnkBtn"
   onmouseover="this.className='lnkBtn btnhov'" onmouseout="this.className='lnkBtn'"
   onClick="window.open('a_loanItemReview.cfm?transaction_id=#transaction_id#','#client.target#');">
   <br />
   Print: <select name="redir" size="1" onchange="if(this.value.length>0){window.open(this.value,'_blank')};">
   			<option value=""></option>
			<cfif #cgi.HTTP_HOST# contains "arctos.database">
				<option value="/Reports/UAMMammLoanInvoice.cfm?transaction_id=#transaction_id#">UAM Mammal Invoice Header</option>
				<option value="/Reports/UAMMammLoanInvoice.cfm?transaction_id=#transaction_id#&Action=itemList">UAM Mammal Item Invoice</option>
				<option value="/Reports/UAMMammLoanInvoice.cfm?transaction_id=#transaction_id#&Action=showCondition">UAM Mammal Item Conditions</option>
				
				<option value="/Reports/MSBMammLoanInvoice.cfm?transaction_id=#transaction_id#">MSB Mammal Invoice Header</option>
				<option value="/Reports/MSBMammLoanInvoice.cfm?transaction_id=#transaction_id#&Action=itemList">MSB Mammal Item Invoice</option>
				
				<option value="/Reports/MSBBirdLoanInvoice.cfm?transaction_id=#transaction_id#">MSB Bird Invoice Header</option>
				<option value="/Reports/MSBBirdLoanInvoice.cfm?transaction_id=#transaction_id#&Action=itemList">MSB Bird Item Invoice</option>
				
				<option value="/Reports/UAMLoanInvoice.cfm?transaction_id=#transaction_id#">UAM Generic Invoice Header</option>
				<option value="/Reports/UAMLoanInvoice.cfm?transaction_id=#transaction_id#&Action=itemList">UAM Generic Item Invoice</option>
				<option value="/Reports/UAMLoanInvoice.cfm?transaction_id=#transaction_id#&Action=showCondition">UAM Generic Item Conditions</option>
				<option value="/Reports/loanShipLabel.cfm?transaction_id=#transaction_id#">Shipping Label</option>
   			<cfelse>
				<option value="/Reports/MVZLoanInvoice.cfm?transaction_id=#transaction_id#">Invoice Header</option>
				<option value="/Reports/MVZLoanInvoice.cfm?transaction_id=#transaction_id#&Action=itemList">Item Invoice</option>
				<option value="/Reports/MVZLoanInvoice.cfm?transaction_id=#transaction_id#&Action=showCondition">Item Conditions</option>
				<option value="/Reports/MVZLoanInvoice.cfm?transaction_id=#transaction_id#&Action=itemLabels">Item Slips</option>
				<option value="/Reports/MVZLoanInvoice.cfm?transaction_id=#transaction_id#&Action=shippingLabel">MVZ shipping label</option>
			</cfif>
		</select>
		
   
   
			
			</td>
	</tr>
</table>
</cfform>

	</cfoutput>
	
	
<cfquery name="ship" datasource="#Application.web_user#">
	select * from shipment where transaction_id = #transaction_id#
</cfquery>
<cfquery name="ctShip" datasource="#Application.web_user#">
	select shipped_carrier_method from ctshipped_carrier_method
</cfquery>
<cfif ship.recordcount gt 0>
	<!--- get some other info --->
	<cfquery name="packed_by_agent" datasource="#Application.web_user#">
		select agent_name from preferred_agent_name where 
		agent_id = #ship.packed_by_agent_id#
	</cfquery>
		<cfset packed_by_agent = "#packed_by_agent.agent_name#">
		<cfset packed_by_agent_id = #ship.packed_by_agent_id#>
		<cfset thisCarrier = #ship.shipped_carrier_method#>
		<cfset carriers_tracking_number = #ship.carriers_tracking_number#>
		<cfset shipped_date = #ship.shipped_date#>
		<cfset package_weight = #ship.package_weight#>
		<cfset hazmat_fg = #ship.hazmat_fg#>
		<cfset INSURED_FOR_INSURED_VALUE = #ship.INSURED_FOR_INSURED_VALUE#>
		<cfset shipment_remarks = #ship.shipment_remarks#>
		<cfset contents = #ship.contents#>
		<cfset FOREIGN_SHIPMENT_FG = #ship.FOREIGN_SHIPMENT_FG#>
	<cfquery name="shipped_to_addr_id" datasource="#Application.web_user#">
		select formatted_addr from addr where 
		addr_id = #ship.shipped_to_addr_id#
	</cfquery>
		<cfset shipped_to_addr = "#shipped_to_addr_id.formatted_addr#">
		<cfset shipped_to_addr_id = #ship.shipped_to_addr_id#>
	<cfquery name="shipped_from_addr_id" datasource="#Application.web_user#">
		select formatted_addr from addr where 
		addr_id = #ship.shipped_from_addr_id#
	</cfquery>
		<cfset shipped_from_addr = "#shipped_from_addr_id.formatted_addr#">
		<cfset shipped_from_addr_id = #ship.shipped_from_addr_id#>
		
  <cfelse>
  	<cfset packed_by_agent = "">
	<cfset packed_by_agent_id = "">
	<cfset thisCarrier = "">
	<cfset carriers_tracking_number = "">
	<cfset shipped_date = "">
	<cfset package_weight = "">
	<cfset hazmat_fg = "">
	<cfset INSURED_FOR_INSURED_VALUE = "">
	<cfset shipment_remarks = "">
	<cfset contents = "">
	<cfset FOREIGN_SHIPMENT_FG = "">
	<cfset shipped_to_addr = "">
	<cfset shipped_to_addr_id = "">
	<cfset shipped_from_addr = "">
	<cfset shipped_from_addr_id = "">
</cfif>
<hr>
Shipment Information:
<table>
<cfoutput>
	<form name="shipment" method="post" action="Loan.cfm">
		<input type="hidden" name="Action" value="saveShip">
		<input type="hidden" name="transaction_id" value="#transaction_id#">
		<tr><td align="right">
		Packed By:
		</td>
		<td>
		<input type="text" name="packed_by_agent" class="reqdClr" size="50" value="#packed_by_agent#"
			  onchange="getAgent('packed_by_agent_id','packed_by_agent','shipment',this.value); return false;"
			  onKeyPress="return noenter(event);"> 
			<input type="hidden" name="packed_by_agent_id" value="#packed_by_agent_id#">
		</td>
		</tr>
		<tr>
			<td align="right">Shipped Method:</td>
			<td><select name="shipped_carrier_method" size="1" class="reqdClr">
				<option value=""></option>
				<cfloop query="ctShip">
					<option 
						<cfif #ctShip.shipped_carrier_method# is "#thisCarrier#"> selected </cfif>value="#ctShip.shipped_carrier_method#">#ctShip.shipped_carrier_method#</option>
				</cfloop>
			</select></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>
				<em><font size="-1">Please note: Linebreaks may have been replaced with "-" in order to make the
				JavaScript picks work. The address will be formatted properly after save.</font></em>
			</td>
		</tr>
		<tr>
			<td align="right" valign="top">Shipped To Address:</td>
			<td><textarea name="shipped_to_addr" cols="60" rows="5" readonly="yes" class="reqdClr">#shipped_to_addr#</textarea>
				<input type="hidden" name="shipped_to_addr_id" value="#shipped_to_addr_id#">
			 <input type="button" value="Pick" class="picBtn"
   onmouseover="this.className='picBtn btnhov'" onmouseout="this.className='picBtn'"
   onClick="addrPick('shipped_to_addr_id','shipped_to_addr','shipment'); return false;">
</td>
		</tr>
		<tr>
		  <td align="right" valign="top">Shipped From Address:
			</td>
			<td>
			<textarea name="shipped_from_addr" cols="60" rows="5" readonly="yes" class="reqdClr">#shipped_from_addr#</textarea>
				<input type="hidden" name="shipped_from_addr_id" value="#shipped_from_addr_id#">
			 <input type="button" value="Pick" class="picBtn"
   onmouseover="this.className='picBtn btnhov'" onmouseout="this.className='picBtn'"
   onClick="addrPick('shipped_from_addr_id','shipped_from_addr','shipment'); return false;">
   </td>
		</tr>
		<tr>
			<td align="right">Tracking ##: </td>
			<td><input type="text" value="#carriers_tracking_number#" name="carriers_tracking_number"></td>
		</tr>
		<tr>
			<td align="right">Ship Date:</td>
			<td><input type="text" value="#dateformat(shipped_date,'dd mmm yyyy')#" name="shipped_date"></td>
		</tr>
		<tr>
			<td align="right">Package Weight:</td>
			<td><input type="text" value="#package_weight#" name="package_weight"></td>
		</tr>
		<tr>
			<td align="right">Hazmat?:</td>
			<td><select name="hazmat_fg" size="1">
				<option <cfif #hazmat_fg# is 0> selected </cfif>value="0">no</option>
				<option <cfif #hazmat_fg# is 1> selected </cfif>value="1">yes</option>
			</select></td>
		</tr>
		<tr>
			<td align="right">Insured Value:</td>
			<td><input type="text" value="#INSURED_FOR_INSURED_VALUE#" name="INSURED_FOR_INSURED_VALUE"></td>
		</tr>
		<tr>
			<td align="right">Remarks:</td>
			<td><input type="text" value="#shipment_remarks#" name="shipment_remarks"></td>
		</tr>
		<tr>
			<td align="right">Contents:</td>
			<td><input type="text" value="#contents#" name="contents"></td>
		</tr>
		<tr>
			<td align="right">Foreign shipment?: </td>
			<td><select name="FOREIGN_SHIPMENT_FG" size="1">
				<option <cfif #FOREIGN_SHIPMENT_FG# is 0> selected </cfif>value="0">no</option>
				<option <cfif #FOREIGN_SHIPMENT_FG# is 1> selected </cfif>value="1">yes</option>
			</select></td>
		</tr>
		
		<tr>
			<td colspan="2">
			<input type="submit" value="Save Shipment" class="savBtn"
   onmouseover="this.className='savBtn btnhov'" onmouseout="this.className='savBtn'">	
   </td>
			
		</tr>
		
	</form>
	
</cfoutput>
</table>

<cfquery name="getPermits" datasource="#Application.web_user#">
	SELECT 
		permit.permit_id,
		issuedBy.agent_name as IssuedByAgent,
		issuedTo.agent_name as IssuedToAgent,
		issued_Date,
		renewed_Date,
		exp_Date,
		permit_Num,
		permit_Type,
		permit_remarks	
	FROM
		permit, 
		permit_trans, 
		preferred_agent_name issuedTo, 
		preferred_agent_name issuedBy
	WHERE
		permit.permit_id = permit_trans.permit_id AND
		permit.issued_by_agent_id = issuedBy.agent_id AND
		permit.issued_to_agent_id = issuedTo.agent_id AND
		permit_trans.transaction_id = #loanDetails.transaction_id#
</cfquery>
<br><strong>Permits:</strong>  
<cfoutput query="getPermits">

<form name="killPerm#currentRow#" method="post" action="Loan.cfm">
<p><strong>Permit ## #permit_Num# (#permit_Type#)</strong> issued to
 #IssuedToAgent# by #IssuedByAgent# on 
#dateformat(issued_Date,"dd mmm yyyy")#. 
<cfif len(#renewed_Date#) gt 0> 
	(renewed #renewed_Date#)
</cfif>Expires #dateformat(exp_Date,"dd mmm yyyy")#  
<cfif len(#permit_remarks#) gt 0>Remarks: #permit_remarks# </cfif> 
<br>
<input type="hidden" name="transaction_id" value="#transaction_id#">
	<input type="hidden" name="action" value="delePermit">
	<input type="hidden" name="permit_id" value="#permit_id#">
	 <input type="submit" value="Remove this Permit" class="delBtn"
   onmouseover="this.className='delBtn btnhov'" onmouseout="this.className='delBtn'">	
</form>
</cfoutput>
<form name="addPermit" action="Loan.cfm" method="post">
	<input type="hidden" name="transaction_id" value="#transaction_id#">
	<input type="hidden" name="permit_id">
	<cfoutput>
	  <input type="button" value="Add a permit" class="picBtn"
   onmouseover="this.className='picBtn btnhov'" onmouseout="this.className='picBtn'"
   onClick="javascript: window.open('picks/PermitPick.cfm?transaction_id=#transaction_id#', 'PermitPick', 
'resizable,scrollbars=yes,width=600,height=600')">	
</form>
</cfoutput>

</cfif>
<!-------------------------------------------------------------------------------------------------->

<cfif #Action# is "delePermit">
<cfquery name="killPerm" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
			DELETE FROM permit_trans WHERE transaction_id = #transaction_id# and 
			permit_id=#permit_id#
		</cfquery>
		<cflocation url="Loan.cfm?Action=editLoan&transaction_id=#transaction_id#">
</cfif>
<!-------------------------------------------------------------------------------------------------->
<cfif #Action# is "saveShip">
	<cfoutput>
		<cfquery name="isShip" datasource="#Application.web_user#">
			select * from shipment where transaction_id = #transaction_id#
		</cfquery>
		<cfif #isShip.recordcount# is 0>
			<!--- new record --->
			<cfquery name="newShip" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				INSERT INTO shipment (
					 TRANSACTION_ID
					 ,PACKED_BY_AGENT_ID
					 ,SHIPPED_CARRIER_METHOD
					 <cfif len(#CARRIERS_TRACKING_NUMBER#) gt 0>
					 	,CARRIERS_TRACKING_NUMBER
					 </cfif>
					 <cfif len(#SHIPPED_DATE#) gt 0>
					 	,SHIPPED_DATE
					 </cfif> 
					 <cfif len(#PACKAGE_WEIGHT#) gt 0>
					 	,PACKAGE_WEIGHT
					 </cfif>
					 ,HAZMAT_FG
					 <cfif len(#INSURED_FOR_INSURED_VALUE#) gt 0>
					 	,INSURED_FOR_INSURED_VALUE
					 </cfif>
					 <cfif len(#SHIPMENT_REMARKS#) gt 0>
					 	,SHIPMENT_REMARKS
					 </cfif> 
					 <cfif len(#CONTENTS#) gt 0>
					 	,CONTENTS
					 </cfif>
					 ,FOREIGN_SHIPMENT_FG
					 ,SHIPPED_TO_ADDR_ID
					 ,SHIPPED_FROM_ADDR_ID)
				VALUES (
					 #TRANSACTION_ID#
					 ,#PACKED_BY_AGENT_ID#
					 ,'#SHIPPED_CARRIER_METHOD#'
					 <cfif len(#CARRIERS_TRACKING_NUMBER#) gt 0>
					 	,'#CARRIERS_TRACKING_NUMBER#'
					 </cfif>
					 <cfif len(#SHIPPED_DATE#) gt 0>
					 	,'#dateformat(SHIPPED_DATE,"dd-mmm-yyyy")#'
					 </cfif> 
					 <cfif len(#PACKAGE_WEIGHT#) gt 0>
					 	,'#PACKAGE_WEIGHT#'
					 </cfif>
					 ,#HAZMAT_FG#
					 <cfif len(#INSURED_FOR_INSURED_VALUE#) gt 0>
					 	,'#INSURED_FOR_INSURED_VALUE#'
					 </cfif>
					 <cfif len(#SHIPMENT_REMARKS#) gt 0>
					 	,'#SHIPMENT_REMARKS#'
					 </cfif> 
					 <cfif len(#CONTENTS#) gt 0>
					 	,'#CONTENTS#'
					 </cfif>
					 ,#FOREIGN_SHIPMENT_FG#
					 ,#SHIPPED_TO_ADDR_ID#
					 ,#SHIPPED_FROM_ADDR_ID#)

			</cfquery>
		  <cfelse>
		  	<!--- update --->
			<cfquery name="upShip" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				 UPDATE shipment SET
					PACKED_BY_AGENT_ID = #PACKED_BY_AGENT_ID#
					,SHIPPED_CARRIER_METHOD = '#SHIPPED_CARRIER_METHOD#'
					 <cfif len(#CARRIERS_TRACKING_NUMBER#) gt 0>
					 	,CARRIERS_TRACKING_NUMBER='#CARRIERS_TRACKING_NUMBER#'
					  <cfelse>
					  	,CARRIERS_TRACKING_NUMBER=null
					 </cfif>
					 <cfif len(#SHIPPED_DATE#) gt 0>
					 	,SHIPPED_DATE='#dateformat(SHIPPED_DATE,"dd-mmm-yyyy")#'
					  <cfelse>
					  	,SHIPPED_DATE=null
					 </cfif> 
					 <cfif len(#PACKAGE_WEIGHT#) gt 0>
					 	,PACKAGE_WEIGHT='#PACKAGE_WEIGHT#'
					  <cfelse>
					  	,PACKAGE_WEIGHT=null
					 </cfif>
					 ,HAZMAT_FG=#HAZMAT_FG#
					 <cfif len(#INSURED_FOR_INSURED_VALUE#) gt 0>
					 	,INSURED_FOR_INSURED_VALUE='#INSURED_FOR_INSURED_VALUE#'
					  <cfelse>
					  	,INSURED_FOR_INSURED_VALUE=null
					 </cfif>
					 <cfif len(#SHIPMENT_REMARKS#) gt 0>
					 	,SHIPMENT_REMARKS='#SHIPMENT_REMARKS#'
					  <cfelse>
					  ,	SHIPMENT_REMARKS=null
					 </cfif> 
					 <cfif len(#CONTENTS#) gt 0>
					 	,CONTENTS='#CONTENTS#'
					  <cfelse>
					  	,CONTENTS=null
					 </cfif>
					 ,FOREIGN_SHIPMENT_FG=#FOREIGN_SHIPMENT_FG#
					 ,SHIPPED_TO_ADDR_ID=#SHIPPED_TO_ADDR_ID#
					 ,SHIPPED_FROM_ADDR_ID=#SHIPPED_FROM_ADDR_ID#
				WHERE
					 transaction_id = #TRANSACTION_ID#
			</cfquery>
		</cfif>
		<cflocation url="Loan.cfm?Action=editLoan&transaction_id=#transaction_id#">
		
	</cfoutput>
</cfif>
<!-------------------------------------------------------------------------------------------------->


<!-------------------------------------------------------------------------------------------------->
<cfif #Action# is "saveEdits">

	<cfoutput>
		<cftransaction>
			<cfquery name="upTrans" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				UPDATE  trans  SET 
					institution_acronym='#institution_acronym#',
					transaction_id = #transaction_id#,
					TRANS_DATE = '#dateformat(initiating_date,"dd-mmm-yyyy")#'
					,NATURE_OF_MATERIAL = '#NATURE_OF_MATERIAL#'
					<cfif len(#trans_remarks#) gt 0>
						,trans_remarks = '#trans_remarks#'
					  <cfelse>
					  	,trans_remarks = null
					</cfif>
				where 
					transaction_id = #transaction_id#
			</cfquery>
			<cfquery name="upLoan" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				 UPDATE loan SET 
					TRANSACTION_ID = #TRANSACTION_ID#,
					LOAN_TYPE = '#LOAN_TYPE#',
					LOAN_NUMber = '#loan_number#'
					<cfif len(#return_due_date#) gt 0>
						,return_due_date = '#dateformat(return_due_date,"dd-mmm-yyyy")#'
					</cfif>
					<cfif len(#loan_status#) gt 0>
						,loan_status = '#loan_status#'						
					  <cfelse>
					  	,loan_status = null
					</cfif>
					<cfif len(#loan_description#) gt 0>
						,loan_description = '#loan_description#'						
					  <cfelse>
					  	,loan_description = null
					</cfif>
					<cfif len(#LOAN_INSTRUCTIONS#) gt 0>
						,LOAN_INSTRUCTIONS = '#LOAN_INSTRUCTIONS#'						
					  <cfelse>
					  	,LOAN_INSTRUCTIONS = null
					</cfif>
					where transaction_id = #transaction_id#
				</cfquery>
				<cfif isdefined("project_id") and len(#project_id#) gt 0>
					<cfquery name="newProj" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
						INSERT INTO project_trans (
							project_id, transaction_id)
							VALUES (
								#project_id#,#transaction_id#)
					</cfquery>
				</cfif>
				<cfif isdefined("saveNewProject") and saveNewProject is "yes">
					<!--- create a new project based on this loan --->
					<cfquery name="nextID" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
						select max(project_id) + 1 as nextid from project
					</cfquery>
					<cfquery name="newProj" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
						INSERT INTO project (
							PROJECT_ID,
							PROJECT_NAME
							<cfif len(#START_DATE#) gt 0>
								,START_DATE
							</cfif>
							<cfif len(#END_DATE#) gt 0>
								,END_DATE
							</cfif>
							<cfif len(#PROJECT_DESCRIPTION#) gt 0>
								,PROJECT_DESCRIPTION
							</cfif>
							<cfif len(#PROJECT_REMARKS#) gt 0>
								,PROJECT_REMARKS
							</cfif>
							 )
						VALUES ( 
							#nextID.nextid#,
							'#PROJECT_NAME#'
							<cfif len(#START_DATE#) gt 0>
								,'#dateformat(START_DATE,"dd-mmm-yyyy")#'
							</cfif>
							
							<cfif len(#END_DATE#) gt 0>
								,'#dateformat(END_DATE,"dd-mmm-yyyy")#'
							</cfif>
							<cfif len(#PROJECT_DESCRIPTION#) gt 0>
								,'#PROJECT_DESCRIPTION#'
							</cfif>
							<cfif len(#PROJECT_REMARKS#) gt 0>
								,'#PROJECT_REMARKS#'
							</cfif>
							 )   
					</cfquery>  
					<cfquery name="newProjAgnt" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
						 INSERT INTO project_agent (
							 PROJECT_ID,
							 AGENT_NAME_ID,
							 PROJECT_AGENT_ROLE,
							 AGENT_POSITION )
						VALUES (
							#nextID.nextid#,
							 #newAgent_name_id#,
							 '#project_agent_role#',
							 1                   
							)                 
					</cfquery>
					<cfquery name="newTrans" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
						INSERT INTO project_trans (project_id, transaction_id) values (#nextID.nextid#, #transaction_id#)
					</cfquery>
				</cfif>
				<!--- get the stuff that's already in there as agents and loop over it to evaluate what happened --->
				<cfquery name="wutsThere" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
					select * from trans_agent where transaction_id=#transaction_id#
					and trans_agent_role !='entered by'
				</cfquery>
				<cfloop query="wutsThere">
					<!--- first, see if the deleted - if so, nothing else matters --->
					<cfif isdefined("del_agnt_#trans_agent_id#")>
						<cfquery name="wutsThere" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
							delete from trans_agent where trans_agent_id=#trans_agent_id#
						</cfquery>
					<cfelse>
						<!--- update, just in case --->
						<cfset thisAgentId = evaluate("trans_agent_id_" & trans_agent_id)>
						<cfset thisRole = evaluate("trans_agent_role_" & trans_agent_id)>
						<cfquery name="wutsThere" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
							update trans_agent set
								agent_id = #thisAgentId#,
								trans_agent_role = '#thisRole#'
							where
								trans_agent_id=#trans_agent_id#
						</cfquery>
					</cfif>
				</cfloop>
				<cfif isdefined("new_trans_agent_id") and len(#new_trans_agent_id#) gt 0>
					<cfquery name="newAgent" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
						insert into trans_agent (
							transaction_id,
							agent_id,
							trans_agent_role
						) values (
							#transaction_id#,
							#new_trans_agent_id#,
							'#new_trans_agent_role#'
						)
					</cfquery>
				</cfif>
			</cftransaction>
			<cflocation url="Loan.cfm?Action=editLoan&transaction_id=#transaction_id#">
			<!---

			--->
	</cfoutput>

</cfif>


<!-------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------->
<cfif isdefined("Action") AND #action# is "makeLoan">
	<cfoutput>
		<!--- get the next loan_number --->
		<cfquery name="nextTransId" datasource="#Application.web_user#">
			select max(transaction_id) + 1 as nextTransactionId from trans
		</cfquery>
		<!------#loan_type# - #loan_num# - #initiating_date# - #loan_num_suffix# - #rec_agent_id# - #loan_num# - #auth_agent_id#---
		<cfabort>--->
		<!--- make sure they filled in all the good stuff. --->
		<cfif 
			len(#loan_type#) is 0 OR
			len(#loan_number#) is 0 OR
			len(#initiating_date#) is 0 OR
			len(#rec_agent_id#) is 0 OR
			len(#auth_agent_id#) is 0
		>
			<br>Something bad happened.
			<br>You must fill in loan_type, loannumber, authorizing_agent_name, initiating_date, loan_num_prefix, received_agent_name.
			<br>Use your browser's back button to fix the problem and try again.
			<cfabort>
		</cfif>
		<cfif len(#in_house_contact_agent_id#) is 0>
			<cfset in_house_contact_agent_id=#auth_agent_id#>
		</cfif>
		<cfif len(#outside_contact_agent_id#) is 0>
			<cfset outside_contact_agent_id=#REC_AGENT_ID#>
		</cfif>	
	<cftransaction>
			<cfquery name="newLoanTrans" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				INSERT INTO trans (
					TRANSACTION_ID,
					TRANS_DATE,
					CORRESP_FG,
					TRANSACTION_TYPE,
					NATURE_OF_MATERIAL,
					institution_acronym
					<cfif len(#trans_remarks#) gt 0>
						,trans_remarks
					</cfif>)
				VALUES (
					#nextTransId.nextTransactionId#,
					'#initiating_date#',
					0,
					'loan',
					'#NATURE_OF_MATERIAL#',
					'#institution_acronym#'
					<cfif len(#trans_remarks#) gt 0>
						,'#trans_remarks#'
					</cfif>
					)
			</cfquery> 
			<cfquery name="newLoan" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				INSERT INTO loan (
					TRANSACTION_ID,
					LOAN_TYPE,
					LOAN_NUMBER
					<cfif len(#loan_status#) gt 0>
						,loan_status
					</cfif>
					<cfif len(#return_due_date#) gt 0>
						,return_due_date
					</cfif>
					<cfif len(#LOAN_INSTRUCTIONS#) gt 0>
						,LOAN_INSTRUCTIONS
					</cfif>
					<cfif len(#loan_description#) gt 0>
						,loan_description
					</cfif>
					 )
				values (
					#nextTransId.nextTransactionId#,
					'#loan_type#',
					'#loan_number#'
					<cfif len(#loan_status#) gt 0>
						,'#loan_status#'
					</cfif>
					<cfif len(#return_due_date#) gt 0>
						,'#dateformat(return_due_date,"dd-mmm-yyyy")#'
					</cfif>
					<cfif len(#LOAN_INSTRUCTIONS#) gt 0>
						,'#LOAN_INSTRUCTIONS#'
					</cfif>
					<cfif len(#loan_description#) gt 0>
						,'#loan_description#'
					</cfif>
					)
			</cfquery>
			<cfquery name="authBy" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				INSERT INTO trans_agent (
				    transaction_id,
				    agent_id,
				    trans_agent_role
				) values (
					#nextTransId.nextTransactionId#,
					#auth_agent_id#,
					'authorized by')
			</cfquery>
			<cfquery name="in_house_contact" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				INSERT INTO trans_agent (
				    transaction_id,
				    agent_id,
				    trans_agent_role
				) values (
					#nextTransId.nextTransactionId#,
					#in_house_contact_agent_id#,
					'in-house contact')
			</cfquery>
			<cfquery name="outside_contact" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				INSERT INTO trans_agent (
				    transaction_id,
				    agent_id,
				    trans_agent_role
				) values (
					#nextTransId.nextTransactionId#,
					#outside_contact_agent_id#,
					'outside contact')
			</cfquery>
			<cfquery name="newLoan" datasource="user_login" username="#client.username#" password="#decrypt(client.epw,cfid)#">
				INSERT INTO trans_agent (
				    transaction_id,
				    agent_id,
				    trans_agent_role
				) values (
					#nextTransId.nextTransactionId#,
					#REC_AGENT_ID#,
					'received by')
			</cfquery>
		</cftransaction>	
		<cflocation url="Loan.cfm?Action=editLoan&transaction_id=#nextTransId.nextTransactionId#">
	</cfoutput>
</cfif>
<!-------------------------------------------------------------------------------------------------->

<!-------------------------------------------------------------------------------------------------->
<cfif #action# is "addItems">
<cfset title="Search for Loans">
	<cfoutput>
	<div style="float:right; clear:left; border:1px solid black; padding:5px;">
			<form action="Loan.cfm" method="post" name="stuff">
				<input type="hidden" name="Action" value="listLoans">
				<input name="notClosed" type="hidden" value="true">
				 <input type="submit" 
				 	value="Find all loans that are not 'closed'" class="schBtn"
   onmouseover="this.className='schBtn btnhov'" onmouseout="this.className='schBtn'">	
			</form>
		</div>
	<cfquery name="ctType" datasource="#Application.web_user#">
		select loan_type from ctloan_type
	</cfquery>
	<cfquery name="ctStatus" datasource="#Application.web_user#">
		select loan_status from ctloan_status
	</cfquery>
	<cfquery name="ctInst" datasource="#Application.web_user#">
		select distinct(institution_acronym) from collection
		order by institution_acronym
	</cfquery>
	<br><form name="SpecData" action="Loan.cfm" method="post">
			<input type="hidden" name="Action" value="listLoans">
			<input type="hidden" name="project_id" <cfif #project_id# gt 0> value = "#project_id#" </cfif>>


	<table>
	<tr>
		<td align="right"><strong>Find Loan:</strong> </td>
		<td>
		<select name="institution_acronym" size="1">
			<option value=""></option>
			<cfloop query="ctInst">
				<option value="#institution_acronym#">#institution_acronym#</option>
			</cfloop>
		</select>
		<input type="text" name="loan_number">
			</td>
	</tr>
	<tr>
		<td align="right">
			<select name="trans_agent_role_1">
				<option value="">Please choose an agent role...</option>
				<cfloop query="cttrans_agent_role">
					<option value="#trans_agent_role#">-> #trans_agent_role#:</option>
				</cfloop>
			</select>
		</td>
		<td>
			<input type="text" name="agent_1"  size="50">
		 </td>
	</tr>
	<tr>
		<td align="right">
			<select name="trans_agent_role_2">
				<option value="">Please choose an agent role...</option>
				<cfloop query="cttrans_agent_role">
					<option value="#trans_agent_role#">-> #trans_agent_role#:</option>
				</cfloop>
			</select>
		</td>
		<td>
			<input type="text" name="agent_2"  size="50">
		 </td>
	</tr>
	<tr>
		<td align="right">
			<select name="trans_agent_role_3">
				<option value="">Please choose an agent role...</option>
				<cfloop query="cttrans_agent_role">
					<option value="#trans_agent_role#">-> #trans_agent_role#:</option>
				</cfloop>
			</select>
		</td>
		<td>
			<input type="text" name="agent_3"  size="50">
		 </td>
	</tr>
	
	<tr>
		<td align="right">Type: </td>
		<td><select name="loan_type">
		<option value=""></option>
					<cfloop query="ctLoanType">
						<option value="#ctLoanType.loan_type#">#ctLoanType.loan_type#</option>
					</cfloop>
				</select>
	<img src="images/nada.gif" width="60" height="1">
	Status:&nbsp;<select name="loan_status">
	<option value=""></option>
					<cfloop query="ctLoanStatus">
						<option value="#ctLoanStatus.loan_status#">#ctLoanStatus.loan_status#</option>
					</cfloop>
				</select>
	</td>
	</tr>
	<tr>
		<td align="right">Transaction Date:</td>
		<td>
		<input name="trans_date" type="text"> To (optional):
		<input type='text' name='to_trans_date'>
		</td>
	</tr>
	<tr>
		<td align="right">
		Due Date:
		</td><td><input type="text" name="return_due_date"> To (optional):
		<input type='text' name='to_return_due_date'>
		</td>
	</tr>
	<tr>
		<td align="right">Permit Number:</td>
		<td>
			<input type="text" name="permit_num" size="50">
				 <span class="infoLink" 
					 onclick="getHelp('get_permit_number');">Pick</span>
			</td>
	</tr>
	<tr>
		<td align="right">Nature of Material:</td>
		<td><textarea name="nature_of_material" rows="3" cols="50"></textarea></td>
	</tr>
	<tr>
		<td align="right">Description: </td>
		<td><textarea name="loan_description" rows="3" cols="50"></textarea></td>
	</tr>
	<tr>
	<tr>
		<td align="right">Instructions:</td>
		<td><textarea name="loan_instructions" rows="3" cols="50"></textarea></td>
	</tr>
	
	<tr>
		<td align="right">Remarks: </td>
		<td><textarea name="trans_remarks" rows="3" cols="50"></textarea></td>
	</tr>
	
		<td colspan="2" align="center">
		
		
		 <input type="submit" value="Find Loans" class="schBtn"
   onmouseover="this.className='schBtn btnhov'" onmouseout="this.className='schBtn'">	
&nbsp;
		   <input type="reset" value="Clear" class="qutBtn"
   onmouseover="this.className='qutBtn btnhov'" onmouseout="this.className='qutBtn'">	
   </td>
	</tr>
</table>
	

		</form>
		
		</cfoutput>
</cfif>
<!-------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------->
<cfif #Action# is "listLoans">
<cfset title="Loan Item List">
<cfset sel = "select 
					trans.transaction_id,
					loan_number,
					loan_type,
					loan_status,
					loan_instructions,
					loan_description,
					concattransagent(trans.transaction_id,'authorized by') auth_agent,
					concattransagent(trans.transaction_id,'entered by') ent_agent,
					concattransagent(trans.transaction_id,'received by') rec_agent,
					nature_of_material,
					trans_remarks,
					return_due_date,
					trans_date,
					project_name,
					project.project_id pid,
					institution_acronym">
<cfset frm = " from 
				loan, 
				trans,
				project_trans,
				project,
				permit_trans,
				permit">
<cfset sql = "where 
				loan.transaction_id = trans.transaction_id AND
				trans.transaction_id = project_trans.transaction_id (+) AND
				project_trans.project_id = project.project_id (+) AND
				loan.transaction_id = permit_trans.transaction_id (+) AND
				permit_trans.permit_id = permit.permit_id (+)">
	<cfif isdefined("trans_agent_role_1") AND len(#trans_agent_role_1#) gt 0>
		<cfset frm="#frm#,trans_agent trans_agent_1">
		<cfset sql="#sql# and trans.transaction_id = trans_agent_1.transaction_id">
		<cfset sql = "#sql# AND trans_agent_1.trans_agent_role = '#trans_agent_role_1#'">
	</cfif>
	<cfif isdefined("agent_1") AND len(#agent_1#) gt 0>
		<cfif #sql# does not contain "trans_agent_1">
			<cfset frm="#frm#,trans_agent trans_agent_1">
			<cfset sql="#sql# and trans.transaction_id = trans_agent_1.transaction_id">
		</cfif>
		<cfset frm="#frm#,preferred_agent_name trans_agent_name_1">
		<cfset sql="#sql# and trans_agent_1.agent_id = trans_agent_name_1.agent_id">
		<cfset sql = "#sql# AND upper(trans_agent_name_1.agent_name) like '%#ucase(agent_1)#%'">
	</cfif>
	<cfif isdefined("trans_agent_role_2") AND len(#trans_agent_role_2#) gt 0>
		<cfset frm="#frm#,trans_agent trans_agent_2">
		<cfset sql="#sql# and trans.transaction_id = trans_agent_2.transaction_id">
		<cfset sql = "#sql# AND trans_agent_2.trans_agent_role = '#trans_agent_role_2#'">
	</cfif>
	<cfif isdefined("agent_2") AND len(#agent_2#) gt 0>
		<cfif #sql# does not contain "trans_agent_2">
			<cfset frm="#frm#,trans_agent trans_agent_2">
			<cfset sql="#sql# and trans.transaction_id = trans_agent_2.transaction_id">
		</cfif>
		<cfset frm="#frm#,preferred_agent_name trans_agent_name_2">
		<cfset sql="#sql# and trans_agent_2.agent_id = trans_agent_name_2.agent_id">
		<cfset sql = "#sql# AND upper(trans_agent_name_2.agent_name) like '%#ucase(agent_2)#%'">
	</cfif>
	<cfif isdefined("trans_agent_role_3") AND len(#trans_agent_role_3#) gt 0>
		<cfset frm="#frm#,trans_agent trans_agent_3">
		<cfset sql="#sql# and trans.transaction_id = trans_agent_3.transaction_id">
		<cfset sql = "#sql# AND trans_agent_3.trans_agent_role = '#trans_agent_role_3#'">
	</cfif>
	<cfif isdefined("agent_3") AND len(#agent_3#) gt 0>
		<cfif #sql# does not contain "trans_agent_3">
			<cfset frm="#frm#,trans_agent trans_agent_3">
			<cfset sql="#sql# and trans.transaction_id = trans_agent_3.transaction_id">
		</cfif>
		<cfset frm="#frm#,preferred_agent_name trans_agent_name_3">
		<cfset sql="#sql# and trans_agent_3.agent_id = trans_agent_name_3.agent_id">
		<cfset sql = "#sql# AND upper(trans_agent_name_3.agent_name) like '%#ucase(agent_3)#%'">
	</cfif>
	
	<cfif isdefined("loan_number") AND len(#loan_number#) gt 0>
		<cfset sql = "#sql# AND upper(loan_number) like '%#ucase(loan_number)#%'">
	</cfif>
	<cfif isdefined("permit_num") AND len(#permit_num#) gt 0>
		<cfset sql = "#sql# AND PERMIT_NUM = '#PERMIT_NUM#'">
	</cfif>
	<cfif isdefined("institution_acronym") AND len(#institution_acronym#) gt 0>
		<cfset sql = "#sql# AND institution_acronym = '#institution_acronym#'">
	</cfif>
	<cfif isdefined("loan_type") AND len(#loan_type#) gt 0>
		<cfset sql = "#sql# AND loan_type = '#loan_type#'">
	</cfif>
	<cfif isdefined("loan_status") AND len(#loan_status#) gt 0>
		<cfset sql = "#sql# AND loan_status = '#loan_status#'">
	</cfif>
	<cfif isdefined("loan_instructions") AND len(#loan_instructions#) gt 0>
		<cfset sql = "#sql# AND upper(loan_instructions) LIKE '%#ucase(loan_instructions)#%'">
	</cfif>
	<cfif isdefined("rec_agent") AND len(#rec_agent#) gt 0>
		<cfset sql = "#sql# AND upper(recAgnt.agent_name) LIKE '%#ucase(rec_agent)#%'">
	</cfif>
	<cfif isdefined("auth_agent") AND len(#auth_agent#) gt 0>
		<cfset sql = "#sql# AND upper(authAgnt.agent_name) LIKE '%#ucase(auth_agent)#%'">
	</cfif>
	<cfif isdefined("ent_agent") AND len(#ent_agent#) gt 0>
		<cfset sql = "#sql# AND upper(entAgnt.agent_name) LIKE '%#ucase(ent_agent)#%'">
	</cfif>
	<cfif isdefined("nature_of_material") AND len(#nature_of_material#) gt 0>
		<cfset sql = "#sql# AND upper(nature_of_material) LIKE '%#ucase(nature_of_material)#%'">
	</cfif>
	<cfif isdefined("return_due_date") and len(#return_due_date#) gt 0>
		<cfif isdefined("to_return_due_date") and len(#to_return_due_date#) gt 0>
			<cfset sql = "#sql# AND return_due_date between '#dateformat(return_due_date, "dd-mmm-yyyy")#'
															and '#dateformat(to_return_due_date, "dd-mmm-yyyy")#'">
		<cfelse>
			<cfset sql = "#sql# AND return_due_date like '#dateformat(return_due_date, "dd-mmm-yyyy")#'">
		</cfif>
	</cfif>	
	<cfif isdefined("trans_date") and len(#trans_date#) gt 0>
		<cfif isdefined("to_trans_date") and len(#to_trans_date#) gt 0>
			<cfset sql = "#sql# AND trans_date between '#dateformat(trans_date, "dd-mmm-yyyy")#'
															and '#dateformat(to_trans_date, "dd-mmm-yyyy")#'">
		<cfelse>
			<cfset sql = "#sql# AND trans_date like '#dateformat(trans_date, "dd-mmm-yyyy")#'">
		</cfif>
	</cfif>
	<cfif isdefined("trans_remarks") AND len(#trans_remarks#) gt 0>
		<cfset sql = "#sql# AND upper(trans_remarks) LIKE '%#ucase(trans_remarks)#%'">
	</cfif>
	<cfif isdefined("loan_description") AND len(#loan_description#) gt 0>
		<cfset sql = "#sql# AND upper(loan_description) LIKE '%#ucase(loan_description)#%'">
	</cfif>
	<cfif isdefined("collection_object_id") AND len(#collection_object_id#) gt 0>
		<cfset frm="#frm#, loan_item">
		<cfset sql = "#sql# AND loan.transaction_id=loan_item.transaction_id AND loan_item.collection_object_id IN (#collection_object_id#)">
	</cfif>
	<cfif isdefined("notClosed") AND len(#notClosed#) gt 0>
		<cfset sql = "#sql# AND loan_status <> 'closed'">
	</cfif>
		<cfif not isdefined("myAgentId") or len(#myAgentId#) is 0>
			You are not a contact for any collection. This form will never return anything.
			<cfabort>
		</cfif>
		<cfquery name="okInst" datasource="#Application.web_user#">
		select institution_acronym from
		collection,
		collection_contacts
		where
		collection.collection_id = collection_contacts.collection_id and
		contact_agent_id = #client.myAgentId#
		group by institution_acronym
	</cfquery>
	<cfif okInst.recordcount is 0>
		You are not a contact for any collection. This form will never return anything.
		<cfabort>
	</cfif>
	<cfset instList = "">
	<cfloop query="okInst">
		<cfif len(#instList#) is 0>
			<cfset instList = "'#institution_acronym#'">
		<cfelse>
			<cfset instList = "#instList#,'#institution_acronym#'">
		</cfif>
	</cfloop>
	<cfset sql = "#sql# AND trans.institution_acronym IN (#instList#)">
	<cfset sql ="#sel# #frm# #sql# ORDER BY loan_num_prefix,loan_num,loan_num_suffix">
	<cfquery name="allLoans" datasource="#Application.web_user#">
		#preservesinglequotes(sql)#
	</cfquery>
	
	
	<cfif #allLoans.recordcount# is 0>
		Nothing matched your search criteria.
	<cfelse>
		<cfoutput>
		<a href="/SpecimenResults.cfm?loan_permit_trans_id=#valuelist(allLoans.transaction_id)#">
			View all items in these loans</a>
		</cfoutput>
	</cfif>
	
	<!----
	<!--- get preferred agent_names to display --->
	<cfquery name="allLoans" dbtype="query">
	 select * from allLoansRaw where transaction_id > 0 
		<cfif len(#allLoansRaw.rec_agnt_type#) gt 0>
			AND rec_agnt_type = 'preferred'
		</cfif>  
		<cfif len(#allLoansRaw.auth_agnt_type#) gt 0>
			AND auth_agnt_type = 'preferred'
		</cfif>  
		<cfif len(#allLoansRaw.ent_agnt_type#) gt 0>
			AND ent_agnt_type = 'preferred'
		</cfif>  
		ORDER BY loan_num_prefix, loan_num, loan_num_suffix, transaction_id					
	</cfquery>
	---->
	
			<table>
			<cfset i=1>
	<cfoutput query="allLoans" group="transaction_id">
		<tr	#iif(i MOD 2,DE("class='evenRow'"),DE("class='oddRow'"))#	>
			<td>
				<table>
					<tr>
						<td colspan="3">
							<strong>#institution_acronym# #loan_number#</strong>
						</td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Recipient:</div></td>
						<td><strong>#rec_agent#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Nature of Material:</div></td>
						<td><strong>#nature_of_material#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Type:</div></td>
						<td><strong>#loan_type#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Status:</div></td>
						<td><strong>#loan_status#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Due Date:</div></td>
						<td><strong>#return_due_date#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Transaction Date:</div></td>
						<td><strong>#dateformat(trans_date,"dd mmm yyyy")#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Instructions:</div></td>
						<td><strong>#loan_instructions#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Authorized By:</div></td>
						<td><strong>#auth_agent#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Entered By:</div></td>
						<td><strong>#ent_agent#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Remarks:</div></td>
						<td><strong>#trans_remarks#</strong></td>
					</tr>
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap><div align="right">Description:</div></td>
						<td><strong>#loan_description#</strong></td>
					</tr>
					
		<tr>
		<td><img src="images/nada.gif" width="30" height="1"></td>
			<td align="right">
			Project:
			</td>
			<td>
				<cfquery name="p" dbtype="query">
					select project_name,pid from allLoans where transaction_id=#transaction_id#
				</cfquery>
				
				<cfloop query="p">
				<cfif len(#P.project_name#)>
					<CFIF #P.RECORDCOUNT# gt 1>
						<img src="/images/li.gif" border="0">
					</CFIF>
					<a href="/Project.cfm?Action=editProject&project_id=#p.pid#"><strong>#P.project_name#</strong></a><BR>
				<cfelse>
					<strong>None</strong>
				</cfif>
				</cfloop>
			</td>
		</tr>
						
					
	
					<tr>
						<td><img src="images/nada.gif" width="30" height="1"></td>
						<td nowrap colspan="2">
						<table width="100%">
							<tr>
								<td align="left">
									<a href="a_loanItemReview.cfm?transaction_id=#transaction_id#">Review Items</a>
								</td>
			<cfif isdefined("client.roles") and listfindnocase(client.roles,"coldfusion_user")>					
									<td>
										<a href="SpecimenSearch.cfm?Action=dispCollObj&transaction_id=#transaction_id#" 
										target="#client.target#">Add Items</a>
									</td>
									<td>
										<a href="Loan.cfm?transaction_id=#transaction_id#&Action=editLoan">Edit Loan</a>
									</td>
									<cfif #project_id# gt 0>
										<td>
										<a href="Project.cfm?Action=addTrans&project_id=#project_id#&transaction_id=#transaction_id#">
									Add To Project</a>
										</td>
									</cfif>
								</cfif>
							</tr>
						</table>
							
								
						</td>
					</tr>
					</table>
					</td>
		</tr>
			
		<cfset i=#i#+1>
	</cfoutput>
</table>
</cfif>
<cfinclude template="includes/_footer.cfm">
<!-------------------------------------------------------------------------------------------------->
