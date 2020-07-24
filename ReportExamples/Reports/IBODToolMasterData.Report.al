/*Name:ToolMasterDataReport
  Description:This sample report example will give an idea to the users that how to create customized Tools report in sToolTracker application 
*/
report 80001 "ToolMasterDataReport"
{
    Caption = 'sToolTracker Tool Master Data';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = Word;
    WordLayout = './ReportTemplates/IBODToolMasterData.docx';
    dataset
    {
        // Table:  "IBOD Tool" Table in sToolTracker application stores the Tools details
        // Primary Key: "Tool No"
        dataitem(IBODTool; "IBOD Tools")
        {
            DataItemTableView = SORTING("Tool No");
            RequestFilterHeading = 'Tool No.';
            RequestFilterFields = "Tool No";
            column(IBODTool_Tool_No; "Tool No")
            {

            }
            column(IBODTool_Description; Description)
            {

            }
            column(IBODTool_Tool_Category_Code; "Tool Category Code")
            {

            }
            column(IBODTool_Tool_Category_Name; CategoryName)
            {

            }
            column(IBODTool_User; UserId)
            {

            }

            column(IBODTool_Default_Location_Code; "Default Location Code")
            {

            }
            column(IBODTool_Blocked; Blocked)
            {

            }
            column(IBODTool_Net_Weight; "Net Weight")
            {

            }
            column(IBODTool_UOM_Net_Weight; "UOM Net Weight")
            {

            }

            column(IBODToolPicture; IBODTool.Picture)
            {

            }
            column(IBODTool_Comments; ToolComments)
            {

            }
            column(IBODTool_BOMs; ToolBOMs)
            {

            }
            column(IBODTool_Attachments; ToolAttachments)
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
            column(ReportNameLbl; ReportNameLbl)
            {

            }
            column(ToolNoLbl; ToolNoLbl)
            {

            }
            column(DescriptionLbl; DescriptionLbl)
            {

            }

            column(ToolCategoryLbl; ToolCategoryLbl)
            {

            }
            column(StorageLocationLbl; StorageLocationLbl)
            {

            }
            column(BlockedLbl; BlockedLbl)
            {

            }

            column(NetWeightLbl; NetWeightLbl)
            {

            }
            column(CommentsLbl; CommentsLbl)
            {

            }

            column(AttachmentsLbl; AttachmentsLbl)
            {

            }

            column(UsedInToolBOMLbl; UsedInToolBOMLbl)
            {

            }
            column(AttributeLbl; AttributeLbl)
            {

            }
            column(AttributeValueLbl; AttributeValueLbl)
            {

            }
            column(UnitOfMeasureLbl; UnitOfMeasureLbl)
            {

            }
            column(AttrBlockedLbl; AttrBlockedLbl)
            {

            }

            // Table:  "IBOD Tools Category" Table in sToolTracker application stores the Tools Category details
            // Primary Key: "Code"
            // Referenced column in "IBOD Tool": "Tool Category Code"
            dataitem(IBODToolCategory; "IBOD Tools Category")
            {
                DataItemLink = Code = FIELD("Tool Category Code");
                DataItemLinkReference = IBODTool;
                column(IBODToolCategory_Description;
                Description)
                {

                }
            }

            ////// Trigger for IBODTool
            trigger OnAfterGetRecord()
            var
                Category: Record "IBOD Tools Category";   // This table stores Tool category details
                Comments: Record "IBOD Tools Comments";  // This table stores Tool comments. Referece key column "Tool No" with "IBO Tool" table is "Tool No"
                Attachments: Record "IBOD Document Attachment"; // This table stores all attachments for the tools. Referece key column "No." with "IBO Tool" table is "Tool No"
                BOMs: Record "IBOD Tool BOM Header"; // This table stores Tool BOM information 
                BOMLine: Record "IBOD Tool BOM Lines";// This table stores Lines details(which has tools information added in that specific BOM))for that specific tool.
                AttrMapping: Record "IBOD Tools Attri Value Mapping"; // This table stores mapped attribute Ids  & attribute Value Ids for the Tool/Tool Categories ("Table ID" column has Object Id for the Tool(70514083) or Tool category(70514080))
                AttrName: Record "IBOD Tools Attribute"; // This table stores the information about for the Tool attributes & it's type(Option,Text,Integer,Decimal or Text)
                AttrVal: Record "IBOD Tools Attribute Values"; // This table stores the actual values(data) of that specific attribute ID
                AttrTrans: Record "IBOD Tools Attr Translation"; // This table stores Translations for attributes.. so that users can create reports in multiples languages 
                AttrValTrans: Record "IBOD Tools Attr Value Trans"; // This table stores the translations for Attributes values.
            begin
                CRLF := '';
                CRLF[1] := 13;
                CRLF[2] := 10;
                ToolComments := '';
                ToolBOMs := '';
                ToolAttachments := '';
                AttrNames := '';
                AttrUOM := '';
                AttrValues := '';
                AttrBlocked := '';
                Category.Reset();
                Category.SetFilter(Code, '=%1', IBODTool."Tool Category Code");
                if (Category.FindSet()) then
                    CategoryName := Category.Description
                else
                    CategoryName := '';
                ///////////// Start Fetch Comments for that specific tools /////////////
                // Fech all Date & Comments for the requested Tool.
                Comments.Reset();
                Comments.SetFilter("Tool No", '=%1', IBODTool."Tool No");
                if (Comments.FindSet()) then
                    repeat
                        ToolComments := ToolComments + format(Comments.Date) + ' ' + Comments.Comment + CRLF;
                    until Comments.Next() = 0;
                ///////////// End Fetch Comments for that specific tools /////////////

                ///////////// Start Fetch  Tool BOM information for  the requested Tool /////////////
                BOMLine.Reset();
                BOMLine.SetFilter("Tool No", '=%1', IBODTool."Tool No");
                if (BOMLine.FindSet()) then
                    repeat
                        BOMs.Reset();
                        BOMs.SetFilter(No, '=%1', BOMLine."Tool BOM No");
                        if (BOMs.FindFirst()) then
                            ToolBOMs := ToolBOMs + BOMs.Description + CRLF;
                    until BOMLine.Next() = 0;
                ///////////// End Fetch  Tool BOM information for  the requested Tool /////////////

                ///////////// Start Fetch Tool Attachments for  the requested Tool /////////////
                Attachments.Reset();
                Attachments.SetFilter("No.", '=%1', IBODTool."Tool No");
                if (Attachments.FindSet()) then
                    repeat
                        ToolAttachments := ToolAttachments + format(Attachments."Attached Date") + ' ' + Attachments."File Name" + CRLF;
                    until Attachments.Next() = 0;
                ///////////// End Fetch  Tool Attachments for  the requested Tool /////////////


                ///////////// Start Fetch Tool Attributes for  the requested Tool /////////////

                recRef.GetTable(IBODTool);   // Get object Id for the tool table
                AttrMapping.Reset();

                // Step 1: Get the mapped attributes & values Ids for the requested tool to by filtering Attribute Mapping table 
                AttrMapping.SetFilter(No, '=%1', IBODTool."Tool No");
                AttrMapping.SetFilter("Table ID", '=%1', recRef.Number);
                if (AttrMapping.FindSet()) then
                    repeat
                        // Step 2: Get the attribute information from the attribute table for the respective Id from the mapping table 
                        /// Get Attribute Details  
                        AttrName.Reset();
                        AttrName.SetFilter(ID, '=%1', AttrMapping."Tool Attribute ID");
                        if (AttrName.FindSet()) then begin
                            AttrNames := AttrNames + AttrName.Name + CRLF;
                            AttrUOM := AttrUOM + AttrName."Unit Of Measure" + CRLF;
                            AttrBlocked := AttrBlocked + format(AttrName.Blocked) + CRLF;
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
        // Get Company name &  logo
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
        ToolBOMName: Text[2048];
        CategoryName: Text[2048];
        ToolComments: Text;
        ToolBOMs: Text;
        ToolAttachments: Text;
        CRLF: Text[2];

        AttrNames: Text;
        AttrValues: Text;
        AttrUOM: Text;
        AttrBlocked: Text;
        //////////////////////////////////////// Labels Start ///////////////////////////////////////////////////
        ToolNoLbl: Label 'Tool No.:';
        DescriptionLbl: Label 'Description:';
        ToolCategoryLbl: Label 'Tool Category:';
        StorageLocationLbl: Label 'Storage Location:';
        BlockedLbl: Label 'Blocked:';
        NetWeightLbl: Label 'Net Weight:';
        CommentsLbl: Label 'Comments:';

        AttachmentsLbl: Label 'Attachments:';
        UsedInToolBOMLbl: Label 'Used in Tool BOMs:';

        AttributeLbl: Label 'Attribute';
        AttributeValueLbl: Label 'Attribute Value';

        UnitOfMeasureLbl: Label 'Unit Of Measure';
        AttrBlockedLbl: Label 'Blocked';
        ReportNameLbl: Label 'Tool Master Data';
        CommentDateLbl: Label 'Date';
        CommentHeaderLbl: Label 'Comment';
    //////////////////////////////////////// Labels End ///////////////////////////////////////////////////
}
