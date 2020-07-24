/*Name:ToolBOM Report
  Description:This sample report example will give an idea to the users that how to create customized Tool BOM report  in sToolTracker application 
*/
report 80000 "ToolBOMReport"
{
    Caption = 'sToolTracker Tool BOM Data';
    UsageCategory = None;
    //   ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './ReportTemplates/IBODToolBOMData.docx';
    dataset
    {
        // Table:  "IBOD Tool BOM Header" Table in sToolTracker application stores the Tool BOM details
        // Primary Key: "No"
        dataitem(ToolBOMHeader; "IBOD Tool BOM Header")
        {
            DataItemTableView = SORTING(No);
            RequestFilterHeading = 'Tool BOM No.';
            RequestFilterFields = No;
            column(ToolBOM_No; No)
            {

            }

            column(BOM_Last_Mod_Date; "Last Modified Date")
            {

            }
            column(BOM_Description; Description)
            {

            }
            column(BOM_Status; Status)
            {

            }

            column(BOM_No_Lbl; BOMNoLbl)
            {

            }
            column(BOM_Date_Lbl; DateLbl)
            {

            }
            column(BOM_Status_Lbl; StatusLbl)
            {

            }
            column(BOM_Toolset_Lbl; ToolsetLbl)
            {

            }
            column(BOM_Qty_Lbl; QtyLbl)
            {

            }
            column(BOM_DescrLbl; DescriptionLbl)
            {

            }
            // Table:  "IBOD Tool BOM Lines" Table in sToolTracker application stores the details about the tools associated with that BOM
            // Reference Key: "Tool BOM No"
            dataitem(IBODTool; "IBOD Tool BOM Lines")
            {
                DataItemLink = "Tool BOM No" = field(No);
                DataItemLinkReference = ToolBOMHeader;
                column(IBODTool_Tool_No; "Tool No")
                {

                }
                column(IBODTool_Description; Description)
                {

                }
                column(IBODTool_Tool_Set; "Tool Set")
                {

                }
                column(IBODTool_Location_Code; "Location Code")
                {

                }
                column(IBODTool_User; UserId)
                {

                }

                column(IBODTool_Quantity; Quantity)
                {
                    DecimalPlaces = 0;
                }
                column(IBODTool_UOM; "Unit Of Measure Code")
                {

                }

                column(IBODToolAttrName; AttrNames)
                {

                }
                column(IBODToolAttrVal; AttrValues)
                {

                }
                column(IBODToolAttrUOM; AttrUOM)
                {

                }
                column(AttrBlocked; AttrBlocked)
                {

                }
                column(ToolBlocked; ToolBlocked)
                {

                }
                column(ReportNameLbl; ReportNameLbl)
                {

                }
                column(ToolNoLbl; ToolNoLbl)
                {

                }
                column(DescriptionLbl; DescriptionLbl)
                {

                }

                column(LocationLbl; LocationLbl)
                {

                }
                column(AttributeLbl; AttributeLbl)
                {

                }
                column(AttributeValueLbl; AttributeValueLbl)
                {

                }
                column(UnitOfMeasureLbl; UOMLbl)
                {

                }
                column(AttrBlockedLbl; AttrBlockedLbl)
                {

                }
                column(QtyLbl; QtyLbl)
                {

                }
                column(ToolsetLbl; ToolsetLbl)
                {

                }

                ////// Trigger for IBODTool
                trigger OnAfterGetRecord()
                var
                    AttrMapping: Record "IBOD Tools Attri Value Mapping";
                    AttrName: Record "IBOD Tools Attribute";
                    AttrVal: Record "IBOD Tools Attribute Values";
                    Tool: Record "IBOD Tools";
                begin
                    CRLF := '';
                    CRLF[1] := 13;
                    CRLF[2] := 10;
                    AttrNames := '';
                    AttrUOM := '';
                    AttrValues := '';
                    AttrBlocked := '';
                    ////// Attributes 
                    recRef.GetTable(Tool);
                    AttrMapping.Reset();
                    // Step 1: Get the mapped attributes & values Ids for the requested tool to by filtering Attribute Mapping table 
                    AttrMapping.SetFilter(No, '=%1', IBODTool."Tool No");
                    AttrMapping.SetFilter("Table ID", '=%1', recRef.Number);
                    if (AttrMapping.FindSet()) then
                        repeat
                            /// Get Attribute Details 
                            // Step 2: Get the attribute information from the attribute table for the respective Id from the mapping table 
                            /// Get Attribute Details  
                            AttrName.Reset();
                            AttrName.SetFilter(ID, '=%1', AttrMapping."Tool Attribute ID");
                            if (AttrName.FindSet()) then begin
                                AttrNames := AttrNames + AttrName.Name + CRLF;
                                AttrUOM := AttrUOM + AttrName."Unit Of Measure" + CRLF;
                                AttrBlocked := AttrBlocked + format(AttrName.Blocked) + CRLF;
                                /// Get Attribute Value 
                                // Step 3: Get the attribute information from the attribute table for the respective Id from the mapping table  
                                /// Get Attribute Value 
                                AttrVal.Reset();
                                AttrVal.SetFilter(ID, '=%1', AttrMapping."Tool Attribute Value ID");
                                AttrVal.SetFilter("Attribute ID", '=%1', AttrName.ID);
                                if (AttrVal.FindSet()) then
                                    AttrValues := AttrValues + AttrVal.Value + CRLF
                                else
                                    AttrValues := AttrValues + '' + CRLF
                            end
                            else begin
                                AttrNames := AttrNames + '' + CRLF;
                                AttrUOM := AttrUOM + '' + CRLF;
                                AttrBlocked := AttrBlocked + '' + CRLF;
                                AttrValues := AttrValues + '' + CRLF;
                            end;
                        until AttrMapping.Next() = 0;

                end;
            }
        }// End of Tool BOM header Data item
        dataitem("Company"; "Company Information")
        {
            column(Picture; Picture)
            {

            }
            column(Company_Name; Name)
            {

            }
        }


    }
    var
        recRef: RecordRef;
        CRLF: Text[2];
        AttrNames: Text;
        AttrValues: Text;
        AttrUOM: Text;
        AttrBlocked: Text;
        ToolBlocked: Text;
        //////////////////////////////////////// Labels Start ///////////////////////////////////////////////////
        BOMNoLbl: Label 'No.:';
        ToolNoLbl: Label 'Tool No.:';
        DateLbl: Label 'Last Modified Date:';
        DescriptionLbl: Label 'Description:';
        StatusLbl: Label 'Status:';
        ToolsetLbl: Label 'Tool Set:';
        LocationLbl: Label 'Use Location Code:';
        QtyLbl: Label 'Quantity:';
        AttributeLbl: Label 'Attribute';
        AttributeValueLbl: Label 'Attribute Value';

        UOMLbl: Label 'Unit Of Measure';
        AttrBlockedLbl: Label 'Blocked';
        ReportNameLbl: Label 'Tool BOM Data';
    //////////////////////////////////////// Labels End ///////////////////////////////////////////////////

}
