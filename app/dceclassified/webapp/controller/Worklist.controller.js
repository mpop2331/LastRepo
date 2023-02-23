/*global location history */
sap.ui.define([
	"be/deloitte/dce/dceclassified/controller/BaseController",
	"sap/m/MessageBox",
	"sap/ui/model/json/JSONModel",
	"be/deloitte/dce/dceclassified/model/formatter",
	"sap/ui/model/odata/v2/ODataModel",
	"sap/ui/model/Filter",
	"sap/ui/core/Fragment",
	"sap/ui/model/FilterOperator",
	"sap/ui/model/Sorter",
	"sap/ui/core/util/Export",
	"sap/ui/core/util/ExportTypeCSV",
	"sap/m/MessageToast",
	"sap/ui/export/Spreadsheet",
	"sap/m/ViewSettingsItem"
], function (BaseController, MessageBox, JSONModel, formatter, ODataModel, Filter, Fragment, FilterOperator, Sorter, Export,
	ExportTypeCSV, MessageToast, Spreadsheet, ViewSettingsItem) {
	"use strict";
	var attrs,
		userRole;
	return BaseController.extend("be.deloitte.dce.dceclassified.controller.Worklist", {
		formatter: formatter,
		/* =========================================================== */
		/* lifecycle methods                                           */
		/* =========================================================== */
		/**
		 * Called when the worklist controller is instantiated.
		 * @public
		 */
		onInit: function () {
			var oViewModel, iOriginalBusyDelay, oTable = this.byId("tabMain");
			oTable.setSticky([
				"ColumnHeaders",
				"HeaderToolbar"
			]);

			iOriginalBusyDelay = oTable.getBusyIndicatorDelay();
			attrs = null;
			userRole = 3;
			this._mGroupFunctions = null;
			delete this._mGroupFunctions;
			// Put down worklist table's original value for busy indicator delay,
			// so it can be restored later on. Busy handling on the table is
			// taken care of by the table itself.
			// Model used to manipulate control states
			oViewModel = new JSONModel({
				worklistTableTitle: this.getResourceBundle().getText("worklistTableTitle"),
				shareOnJamTitle: this.getResourceBundle().getText("worklistTitle"),
				shareSendEmailSubject: this.getResourceBundle().getText("shareSendEmailWorklistSubject"),
				shareSendEmailMessage: this.getResourceBundle().getText("shareSendEmailWorklistMessage", [location.href]),
				tableNoDataText: this.getResourceBundle().getText("tableNoDataText"),
				tableBusyDelay: 0
			});
			this.setModel(oViewModel, "worklistView");
			// Make sure, busy indication is showing immediately so there is no
			// break after the busy indication for loading the view's meta data is
			// ended (see promise 'oWhenMetadataIsLoaded' in AppController)
			oTable.attachEventOnce("updateFinished", function () {
				// Restore original busy indicator delay for worklist's table
				oViewModel.setProperty("/tableBusyDelay", iOriginalBusyDelay);
			});
			//set the groupers function
			this._mGroupFunctions = {
				ID: function (oContext) {
					var name = oContext.getProperty("ID");
					return {
						key: name,
						text: name
					};
				},
				Description: function (oContext) {
					var name = oContext.getProperty("Description");
					return {
						key: name,
						text: name
					};
				},
				Scheme: function (oContext) {
					var name = oContext.getProperty("Scheme");
					return {
						key: name,
						text: name
					};
				},
				Code: function (oContext) {
					var name = oContext.getProperty("Code");
					return {
						key: name,
						text: name
					};
				},
				ClassifiedBy: function (oContext) {
					var name = oContext.getProperty("ClassifiedBy");
					return {
						key: name === null ? "Not Classified" : name,
						text: name
					};
				},
				ClassifiedOn: function (oContext) {
					//Group per day and hours
					var sDate = oContext.getProperty("ClassifiedOn");
					var name;
					if (sDate !== null) {
						var time = sDate.toTimeString().split(":");
						var date = sDate.toJSON().split("T")[0];
						name = date + " " + time[0] + ":" + time[1];
					} else {
						name = "Not Classified";
					}
					return {
						key: name,
						text: name
					};
				},
				UploadedOn: function (oContext) {
					//Group per day and hours
					var sDate = oContext.getProperty("UploadedOn");
					var name;
					if (sDate !== null) {
						var time = sDate.toTimeString().split(":");
						var date = sDate.toJSON().split("T")[0];
						name = date + " " + time[0] + ":" + time[1];
					} else {
						name = "Not Classified";
					}
					return {
						key: name,
						text: name
					};
				}

			};

			var tha = this;

			this.byId("fbcbScheme").addEventDelegate({
				onAfterRendering: function () {
					tha.byId("fbcbScheme").$().find("input").attr("readonly", true);
				}
			});

			//set the initial date range to only show classifications from the past 7 days
			var oldDate = new Date(Date.now()),
				newDate = new Date(Date.now());
			oldDate.setDate(oldDate.getDate() + (-7));

			this.byId("fbsfClassOn").setDateValue(oldDate);
			this.byId("fbsfClassOn").setSecondDateValue(newDate);

			this.getRouter().getRoute("worklist").attachPatternMatched(this._onMasterMatched, this);
			var bModel = new JSONModel();
			
			var client;
			var that = this;
				
				var oModel2 = new ODataModel("/v2/catalog", {
					"disableHeadRequestForToken": true,
					"json": true
				});
				var sorters = [];
				var mySorter = new sap.ui.model.Sorter("ViewAttribute", false);
				sorters.push(mySorter);
				oModel2.read("/ViewAttributes", {
					sorters: sorters,
					success: function (oData2, oResponse2) {
						if (oData2.results.length > 0) {
							tha.getView().byId("tabMain").bindItems({
								path: "/ClassificationsAttr",
								template: tha.getView().byId("tabMain").getBindingInfo("items").template
							});
							var aFilters = tha._getFilters();
							var aSorters = [];
							aSorters.push(new Sorter("ID", false));
							tha.byId("tabMain").getBinding("items").sort(aSorters);
							tha.byId("tabMain").getBinding("items").filter(aFilters);
							attrs = oData2.results;
							//attrs = oData2.results;
							var columnList = tha.getView().byId("colList");
							for (var k = 0; k < oData2.results.length; k++) {
								tha.getView().byId("attr" + parseInt(k + 1)).setLabel(oData2.results[k].Name);
								tha.getView().byId("attr" + parseInt(k + 1)).setVisible(true);

								if (client.AttributeFirst === "1") { //Layout setting attributes before
									tha.getView().byId("tabMain").insertColumn(new sap.m.Column({
										header: new sap.m.Label({
											text: oData2.results[k].Name
										})
									}), k);
									columnList.insertCell(new sap.m.Text({
										text: "{Value" + parseInt(k + 1) + "}"
									}), k);
								} else {
									tha.getView().byId("tabMain").addColumn(new sap.m.Column({
										header: new sap.m.Label({
											text: oData2.results[k].Name
										})
									}));
									columnList.addCell(new sap.m.Text({
										text: "{Value" + parseInt(k + 1) + "}"
									}));
								}

								var name2 = oData2.results[k].Name;
								that._mGroupFunctions[name2] = function (oContext) {
									var name = oContext.getProperty(name2);
									return {
										key: name,
										text: name
									};
								};

							}
						}
					}
				});
		},
		/* =========================================================== */
		/* event handlers                                              */
		/* =========================================================== */
		/**
		 * Triggered by the table's 'updateFinished' event: after new table
		 * data is available, this handler method updates the table counter.
		 * This should only happen if the update was successful, which is
		 * why this handler is attached to 'updateFinished' and not to the
		 * table's list binding's 'dataReceived' method.
		 * @param {sap.ui.base.Event} oEvent the update finished event
		 * @public
		 */
		onUpdateFinished: function (oEvent) {
			// update the worklist's object counter after the table update
			var sTitle, oTable = oEvent.getSource(),
				iTotalItems = oEvent.getParameter("total");
			// only update the counter if the length is final and
			// the table is not empty
			if (iTotalItems && oTable.getBinding("items").isLengthFinal()) {
				sTitle = this.getResourceBundle().getText("worklistTableTitleCount", [iTotalItems]);
			} else {
				sTitle = this.getResourceBundle().getText("worklistTableTitle");
			}
			this.getModel("worklistView").setProperty("/worklistTableTitle", sTitle);
			var aFilterStatus = [];
			aFilterStatus.push(new Filter({
				path: "Object",
				operator: sap.ui.model.FilterOperator.EQ,
				value1: "Classification"
			}));
			this.byId("fbsfStatus").getBinding("items").filter(aFilterStatus);

		},
		/**
		 * Event handler of the filter items and make the search.
		 * @public
		 */
		onSearch: function () {
			var aFilters = this._getFilters();
			this.byId("tabMain").getBinding("items").filter(aFilters);
		},
		/**
		 * Assign classification to your user
		 * @param {sap.ui.base.Event} oEvent the confirm event
		 * @public
		 */
		onAssign: function (oEvent) {
			if (oEvent.getSource().getBindingContext().getProperty("ClassStatus") > 0) {
				MessageBox.error("Already assigned, classified or validated");
				return;
			}
			var that = this;
			that.getView().setBusy(true);
			var oTable = this.byId("tabMain");
			var GUID = oEvent.getSource().getBindingContext().getProperty("GUID");
			var pScheme = oEvent.getSource().getBindingContext().getProperty("Scheme");
			var oModel = new JSONModel();
			var sHeaders = {
				"Content-Type": "application/json",
				"Accept": "application/json"
			};
			var bodyJSON = {
				"GUID": GUID,
				"Scheme": pScheme
			};
			var body = JSON.stringify(bodyJSON);
			oModel.loadData("/dce/env/services/dispatcher.xsjs/Classification?action=assignProduct", body, true, "PUT", null, false, sHeaders);
			oModel.attachRequestCompleted(function (oResult) {
				if (oResult.getParameter("success") === true) {
					that.getView().setBusy(false);
					oTable.getBinding("items").refresh();
					MessageToast.show("Classification was successfully assigned to you!");
				} else {
					that.getView().setBusy(false);
					MessageBox.error("Error during unassigning!");
				}
			});
		},
		/**
		 * Assign classification to your user
		 * @param {sap.ui.base.Event} oEvent the confirm event
		 * @public
		 */
		onAssignSelected: function (oEvent) {
			/*if (oEvent.getSource().getBindingContext().getProperty("ClassStatus") > 0) {
				MessageBox.error("Already assigned, classified or validated");
				return;
			}*/
			var that = this;
			that.getView().setBusy(true);
			var oTable = this.byId("tabMain");
			var aClassifications = [];
			oTable.getSelectedItems().forEach(function (Product) {
				aClassifications.push({
					GUID: Product.getBindingContext().getProperty("GUID"),
					Scheme: Product.getBindingContext().getProperty("Scheme")
				});
			});
			var oModel = new JSONModel();
			var sHeaders = {
				"Content-Type": "application/json",
				"Accept": "application/json"
			};
			var bodyJSON = {
				"Classifications": aClassifications
			};
			var body = JSON.stringify(bodyJSON);
			oModel.loadData("/dce/env/services/dispatcher.xsjs/Classification?action=assignSelected", body, true, "PUT", null, false, sHeaders);
			oModel.attachRequestCompleted(function (oResult) {
				if (oResult.getParameter("success") === true) {
					that.getView().setBusy(false);
					oTable.getBinding("items").refresh();
					MessageToast.show("Classifications are successfully assigned to you!");
				} else {
					that.getView().setBusy(false);
					MessageBox.error("Error during unassigning!");
				}
			});
		},
		/**
		 * Event handler filter clearing.
		 * @public
		 */
		onFBClear: function () {
			this.byId("fbsfProdId").clear();
			this.byId("fbsfProdDesc").clear();
			this.byId("fbcbScheme").setSelectedKey("");
			this.byId("fbsfNsCode").clear();
			this.byId("fbsfClassBy").clear();
			this.byId("fbsfClassOn").setValue(null);
			this.byId("fbsfUploadedOn").setValue(null);
			this.byId("fbsfStatus").setValue(null);
			this.byId("fbsfStatus").setSelectedKey(null);
			this.byId("fbsfAttr1").clear();
			this.byId("fbsfAttr2").clear();
			this.byId("fbsfAttr3").clear();
			this.byId("fbsfAttr4").clear();
			this.byId("fbsfAttr5").clear();
			this.byId("tabMain").getBinding("items").filter([]);
		},
		/**
		 * Event handler to show the filter dialog.
		 * @public
		 */
		onFilterBtnPress: function () {
			var fb = this.byId("mainFilterBar");
			fb.showFilterDialog();
		},
		/**
		 * Event handler for the sort and group buttons to open the ViewSettingsDialog.
		 * @param {sap.ui.base.Event} oEvent the button press event
		 * @public
		 */
		onOpenViewSettings: function (oEvent) {
			var sDialogTab = "sort";
			if (oEvent.getSource() instanceof sap.m.Button) {
				var sButtonId = oEvent.getSource().getId();
				if (sButtonId.match("group")) {
					sDialogTab = "group";
				}
			}
			// load asynchronous XML fragment
			if (this.byId("viewSettingsDialog")) {
				this.byId("viewSettingsDialog").destroy();
			}
			Fragment.load({
				id: this.getView().getId(),
				name: "be.deloitte.dce.dceclassified.view.fragment.ViewSettingsDialog",
				controller: this
			}).then(function (oDialog) {
				// connect dialog to the root view of this component (models, lifecycle)
				this.getView().addDependent(oDialog);
				oDialog.addStyleClass(this.getOwnerComponent().getContentDensityClass());
				oDialog.open(sDialogTab);
			}.bind(this));
			if (attrs && attrs.length > 0) {
				for (var k = 0; k < attrs.length; k++) {
					this.byId("viewSettingsDialog").addSortItem(new ViewSettingsItem({
						key: "Value" + parseInt(k + 1),
						text: attrs[k].Name
					}));
					this.byId("viewSettingsDialog").addGroupItem(new ViewSettingsItem({
						key: "Value" + parseInt(k + 1),
						text: attrs[k].Name
					}));
				}
			}
		},
		/**
		 * Event handler called when ViewSettingsDialog has been confirmed, i.e.
		 * has been closed with 'OK'. In the case, the currently chosen filters, sorters or groupers
		 * are applied to the master list, which can also mean that they
		 * are removed from the master list, in case they are
		 * removed in the ViewSettingsDialog.
		 * @param {sap.ui.base.Event} oEvent the confirm event
		 * @public
		 */
		onConfirmViewSettingsDialog: function (oEvent) {
			var aFilterItems = oEvent.getParameters().filterItems,
				aFilters = [],
				aCaptions = [];
			// update filter state:
			// combine the filter array and the filter string
			aFilterItems.forEach(function (oItem) {
				switch (oItem.getKey()) {
				case "Filter1":
					aFilters.push(new Filter("Priority", FilterOperator.LE, 100));
					break;
				case "Filter2":
					aFilters.push(new Filter("Priority", FilterOperator.GT, 100));
					break;
				default:
					break;
				}
				aCaptions.push(oItem.getText());
			});
			this._applySortGroup(oEvent);
		},
		/**
		 * Event handler when a table item gets pressed
		 * @param {sap.ui.base.Event} oEvent the table selectionChange event
		 * @public
		 */
		onPress: function (oEvent) {
			// The source is the list item that got pressed
			this._showObject(oEvent);
		},
		/**
		 * Event handler to convert the data to CSV and download it
		 * @public
		 */
		onDownload: function () {
			var that = this;
			var oModel = this.getView().getModel();
			var dModel = new JSONModel();
			var sorters = [];
			var mySorter = new sap.ui.model.Sorter("ID", false);
			var mySorterA = new sap.ui.model.Sorter("ClassStatus", true);
			var mySorterScheme = new sap.ui.model.Sorter("Scheme", false);
			var mySorterCode = new sap.ui.model.Sorter("Code", false);
			var attFilters = {};
			if (this.byId("attr1").getVisible() === true && this.byId("fbsfAttr1").getValue()) {
				attFilters[this.byId("attr1").getLabel()] = this.byId("fbsfAttr1").getValue().toUpperCase();
			}
			if (this.byId("attr2").getVisible() === true && this.byId("fbsfAttr2").getValue()) {
				attFilters[this.byId("attr2").getLabel()] = this.byId("fbsfAttr2").getValue().toUpperCase();
			}
			if (this.byId("attr3").getVisible() === true && this.byId("fbsfAttr3").getValue()) {
				attFilters[this.byId("attr3").getLabel()] = this.byId("fbsfAttr3").getValue().toUpperCase();
			}
			if (this.byId("attr4").getVisible() === true && this.byId("fbsfAttr4").getValue()) {
				attFilters[this.byId("attr4").getLabel()] = this.byId("fbsfAttr4").getValue().toUpperCase();
			}
			if (this.byId("attr5").getVisible() === true && this.byId("fbsfAttr5").getValue()) {
				attFilters[this.byId("attr5").getLabel()] = this.byId("fbsfAttr5").getValue().toUpperCase();
			}
			sorters.push(mySorter);
			sorters.push(mySorterScheme);
			sorters.push(mySorterA);
			sorters.push(mySorterCode);
			oModel.read("/ClassComments", {
				sorters: sorters,
				filters: this._getFiltersDownload(),
				urlParameters: {
					"$top": 30000,
					"$skip": 0,
					"$expand": "Attributes"
				},
				success: function (oData, oResponse) {
					oModel.read("/ClientAttributes", {
						success: function (oData2, oResponse2) {

							var oldProduct = {};

							for (var si = 0; si < oData.results.length; si++) {
								if (oldProduct.ID !== oData.results[si].ID || oldProduct.Scheme !== oData.results[si].Scheme) {
									oldProduct.ID = oData.results[si].ID;
									oldProduct.Scheme = oData.results[si].Scheme;
									oldProduct.Status = oData.results[si].Status;
									oldProduct.Code = oData.results[si].Code;
								} else {
									if (oldProduct.Status !== oData.results[si].Status) {
										oData.results[si].ID = "";
										oData.results[si].Description = "";
										oData.results[si].Scheme = "";
										oldProduct.Status = oData.results[si].Status;
										oldProduct.Status = oData.results[si].Status;
									} else {
										if (oldProduct.Code !== oData.results[si].Code) {
											oData.results[si].ID = "";
											oData.results[si].Description = "";
											oData.results[si].Scheme = "";
											oldProduct.Code = oData.results[si].Code;
										} else {
											oData.results[si].ID = "";
											oData.results[si].Description = "";
											oData.results[si].Scheme = "";
											oData.results[si].Code = "";
											oData.results[si].ClassifiedBy = "";
											oData.results[si].ClassifiedOn = "";
											oData.results[si].UploadedOn = "";
											oData.results[si].Status = "";
										}
									}
								}
								oData.results[si].ClassifiedOn = that.formatterDate(oData.results[si].ClassifiedOn);
								oData.results[si].UploadedOn = that.formatterDate(oData.results[si].UploadedOn);
								oData.results[si].CommentOn = that.formatterDate(oData.results[si].CommentOn);
								oData.results[si].Description = that.formatter.specialChar(oData.results[si].Description);
								if (oData2.results.length > 0) {
									var attribute = oData.results[si].Attributes.results;
									for (var j = 0; j < attribute.length; j++) {
										var name = attribute[j].Name;
										var value = attribute[j].Value.toUpperCase();
										if (attFilters[name] && !value.includes(attFilters[name])) {
											oData.results.splice(si, 1);
											si--;
											break;
										}

										oData.results[si][name] = attribute[j].Value;
									}
								}
							}
							dModel.setData(oData.results);
							/*var oExport = new sap.ui.core.util.Export({		CSV download
								// Type that will be used to generate the content. Own ExportType's can be created to support other formats
								exportType: new sap.ui.core.util.ExportTypeCSV({
									separatorChar: ";"
								}),
								// Pass in the model created above
								models: dModel,
								// binding information for the rows aggregation 
								rows: {
									path: "/"
								},
								// column definitions with column name and binding info for the content
								columns: [{
									name: "Scheme",
									template: {
										content: {
											path: "Scheme"
										}
									}
								}, {
									name: "ID",
									template: {
										content: {
											path: "ID"
										}
									}
								}, {
									name: "Description",
									template: {
										content: {
											path: "Description"
										}
									}
								}, {
									name: "Language",
									template: {
										content: {
											path: "Language"
										}
									}
								}, {
									name: "Scheme",
									template: {
										content: {
											path: "Scheme"
										}
									}
								}, {
									name: "Code",
									template: {
										content: {
											path: "Code"
										}
									}
								}, {
									name: "ClassifiedBy",
									template: {
										content: {
											path: "ClassifiedBy"
										}
									}
								}, {
									name: "ClassifiedOn",
									template: {
										content: {
											path: "ClassifiedOn"
										}
									}
								}]
							});
							oExport.generate().done(function (sContent) {
								//console.log(sContent);
							}).always(function () {
								this.destroy();
							});
							oExport.saveFile().always(function () {
								this.destroy();
							});*/
							var headers = that.getCsvHeader(oData2.results);
							var aColumns = [];

							$.each(headers, function (i, head) {
								aColumns.push({
									label: head.description,
									property: head.id
								});
							});

							var mSettings = {
								workbook: {
									columns: aColumns,
									context: {
										sheetName: "Products"
									}
								},
								fileName: "Classified_Products.xlsx",
								dataSource: dModel.getData(),
								showProgress: false
							};
							var oSpreadsheet = new sap.ui.export.Spreadsheet(mSettings);
							oSpreadsheet.build();
						},
						error: function (oError) {
							jQuery.sap.log.error(oError);
							MessageBox.error("Error during the download!");
						}
					});
				}
			});
		},

		formatterDate: function (sDate) {
			if (sDate) {
				var time = sDate.toTimeString().split(":");
				var s = time[2].split("GMT")[0];
				var date = sDate.toJSON().split("T")[0];
				var date2 = date.split("-");
				return date2[2] + "." + date2[1] + "." + date2[0] + " " + time[0] + ":" + time[1] + ":" + s;
			} else {
				return "";
			}
		},
		/**
		 * Create the header of the spreadsheet
		 * @param {sap.ui.base.Event} oEvent the confirm event
		 * @public
		 */
		getCsvHeader: function (attributes) {
			var headers = [];
			var head = {};
			head.id = "ID";
			head.description = "ID";
			headers.push(head);

			var head = {};
			head.id = "Description";
			head.description = "Description";
			headers.push(head);

			if (attributes.length > 0) {
				for (var i = 0; i < attributes.length; i++) {
					var head = {};
					head.id = attributes[i].Name;
					head.description = attributes[i].Name;
					headers.push(head);
				}
			}

			var head = {};
			head.id = "Scheme";
			head.description = "Scheme";
			headers.push(head);

			var head = {};
			head.id = "Code";
			head.description = "Code";
			headers.push(head);

			var head = {};
			head.id = "ClassifiedBy";
			head.description = "ClassifiedBy";
			headers.push(head);

			var head = {};
			head.id = "UploadedOn";
			head.description = "UploadedOn";
			headers.push(head);

			var head = {};
			head.id = "ClassifiedOn";
			head.description = "ClassifiedOn";
			headers.push(head);

			var head = {};
			head.id = "Status";
			head.description = "Status";
			headers.push(head);

			var head = {};
			head.id = "Comment";
			head.description = "Comment";
			headers.push(head);

			var head = {};
			head.id = "CommentBy";
			head.description = "CommentBy";
			headers.push(head);

			var head = {};
			head.id = "CommentOn";
			head.description = "CommentOn";
			headers.push(head);

			/*var head = {};
			head.id = "Attribute7";
			head.description = this.getView().getModel("i18n").getResourceBundle().getText("csvHeaderColumn9");
			headers.push(head);

			var head = {};
			head.id = "Attribute8";
			head.description = this.getView().getModel("i18n").getResourceBundle().getText("csvHeaderColumn10");
			headers.push(head);

			var head = {};
			head.id = "Attribute9";
			head.description = this.getView().getModel("i18n").getResourceBundle().getText("csvHeaderColumn11");
			headers.push(head);

			var head = {};
			head.id = "Attribute10";
			head.description = this.getView().getModel("i18n").getResourceBundle().getText("csvHeaderColumn12");
			headers.push(head);

			var head = {};
			head.id = "Classification";
			head.description = this.getView().getModel("i18n").getResourceBundle().getText("csvHeaderColumn13");

			if (version === 2) {
				headers.push(head);
			}*/
			return headers;
		},
		/* =========================================================== */
		/* internal methods                                            */
		/* =========================================================== */
		_onMasterMatched: function () {
			this.byId("tabMain").getBinding("items").refresh();
			var aFilters = this._getFilters();
			var aSorters = [];
			aSorters.push(new Sorter("ID", false));
			this.byId("tabMain").getBinding("items").sort(aSorters);
			this.byId("tabMain").getBinding("items").filter(aFilters);
		},
		/**
		 * Shows the selected item on the object page
		 * On phones a additional history entry is created
		 * @param {sap.m.ObjectListItem} oItem selected Item
		 * @private
		 */
		_showObject: function (oEvent) {
			var objectid = oEvent.getSource().getBindingContextPath().split("'")[1];
			var scheme = oEvent.getSource().getBindingContext().getProperty("Scheme");
			var productGUID = oEvent.getSource().getBindingContext().getProperty("ProductGUID");
			this.getRouter().navTo("object", {
				objectId: objectid,
				productGUID: productGUID,
				scheme: scheme
			});
		},

		/**
		 * Apply the chosen sorter and grouper to the master list
		 * @param {sap.ui.base.Event} oEvent the confirm event
		 * @private
		 */
		_applySortGroup: function (oEvent) {
			var mParams = oEvent.getParameters(),
				sPath, bDescending, aSorters = [];
			// apply sorter to binding
			// (grouping comes before sorting)
			if (mParams.groupItem) {
				sPath = mParams.groupItem.getKey();
				bDescending = mParams.groupDescending;
				var vGroup = this._mGroupFunctions[sPath];
				aSorters.push(new Sorter(sPath, bDescending, vGroup));
			}
			sPath = mParams.sortItem.getKey();
			bDescending = mParams.sortDescending;
			aSorters.push(new Sorter(sPath, bDescending));
			this.byId("tabMain").getBinding("items").sort(aSorters);
		},
		onDelete: function () {
			var that = this;
			var oModel = new JSONModel();
			var sHeaders = {
				"Content-Type": "application/json"
			};
			that.getView().setBusy(true);
			var oTable = this.byId("tabMain");
			var selItems = oTable.getSelectedItems();
			var Products = [],
				aBody = {};

			MessageBox.confirm("Do you want to delete those classifications? ", {
				actions: [MessageBox.Action.YES, MessageBox.Action.CANCEL],
				icon: MessageBox.Icon.WARNING,
				onClose: function (oAction) {
					if (oAction === "YES") {
						for (var i = 0; i < selItems.length; i++) { //delete by scheme or not?
							Products.push({
								"GUID": selItems[i].getBindingContext().getProperty("GUID"),
								"ProductID": selItems[i].getBindingContext().getProperty("ID"),
								"Scheme": selItems[i].getBindingContext().getProperty("Scheme")
							});
						}
						aBody = {
							"input":{
								"method":"DELETE",
        						"entity":"Classification",
								"body":{
									"Products": Products
								}
							}
						};
						var body = JSON.stringify(aBody);
						that.getView().setBusy(false);
						oModel.loadData("/dispatcher/dispatch", body, true, "POST", null, false, sHeaders);

						oModel.attachRequestCompleted(function (oResult) {
							that.getView().setBusy(false);
							if (oResult.getParameter("success") === true) {
								oTable.getBinding("items").refresh();
								that.byId("btnDelete").setEnabled(false);
								MessageToast.show("Classifications are successfully deleted");
							} else {
								MessageBox.error("Error during deletion!");
							}
							that.onTabSelectChange();
						});
					} else {
						that.getView().setBusy(false);
						return;
					}
				}
			});
		},
		/**
		 * Change Ui when selecting items
		 * @public
		 */
		onTabSelectChange: function () {
			var oPage = this.byId("page");
			var oTable = this.byId("tabMain");
			var btnDel = this.byId("btnDelete");
			var btnAssign = this.byId("btnAssign");
			if (oTable.getSelectedItems().length === 0) {
				btnDel.setEnabled(false);
				oPage.setShowFooter(false);
				btnDel.setVisible(false);
				btnAssign.setVisible(false);
			} else {
				if (userRole > 2) {
					btnDel.setType("Reject");
					btnDel.setEnabled(true);
					oPage.setShowFooter(true);
					btnDel.setVisible(true);
				}
				if (this.byId("fbsfStatus").getSelectedKey() === "0") {
					btnAssign.setEnabled(true);
					btnAssign.setVisible(true);
					if (!oPage.getFooter) {
						oPage.setShowFooter(true);
					}
				}
			}
		},

		_getFilters: function () {
			var aFilters = [];
			var pid = this.byId("fbsfProdId").getValue().trim();
			if (pid.length > 0) {
				aFilters.push(new Filter({
					path: "CIProduct",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: pid.toUpperCase()
				}));
			}
			if (this.byId("attr1").getVisible() === true && this.byId("fbsfAttr1").getValue()) {
				aFilters.push(new Filter({
					path: "CIValue1",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: this.byId("fbsfAttr1").getValue().toUpperCase()
				}));

			}
			if (this.byId("attr2").getVisible() === true && this.byId("fbsfAttr2").getValue()) {
				aFilters.push(new Filter({
					path: "CIValue2",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: this.byId("fbsfAttr2").getValue().toUpperCase()
				}));
			}
			if (this.byId("attr3").getVisible() === true && this.byId("fbsfAttr3").getValue()) {
				aFilters.push(new Filter({
					path: "CIValue3",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: this.byId("fbsfAttr3").getValue().toUpperCase()
				}));
			}
			if (this.byId("attr4").getVisible() === true && this.byId("fbsfAttr4").getValue()) {
				aFilters.push(new Filter({
					path: "CIValue4",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: this.byId("fbsfAttr4").getValue().toUpperCase()
				}));
			}
			if (this.byId("attr5").getVisible() === true && this.byId("fbsfAttr5").getValue()) {
				aFilters.push(new Filter({
					path: "CIValue5",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: this.byId("fbsfAttr5").getValue().toUpperCase()
				}));
			}
			var pdesc = this.byId("fbsfProdDesc").getValue().trim();
			if (pdesc.length > 0) {
				pdesc = formatter.noSpecialChar(pdesc);
				aFilters.push(new Filter({
					path: "CIDescription",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: pdesc.toUpperCase()
				}));
			}
			var sch = this.byId("fbcbScheme");
			if (sch.getSelectedKey() !== "") {
				aFilters.push(new Filter({
					path: "Scheme",
					operator: sap.ui.model.FilterOperator.EQ,
					value1: sch.getSelectedKey()
				}));
			}
			var cod = this.byId("fbsfNsCode").getValue().trim();
			if (cod.length > 0) {
				aFilters.push(new Filter({
					path: "Code",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: cod
				}));
			}
			var cby = this.byId("fbsfClassBy").getValue().trim();
			if (cby.length > 0) {
				aFilters.push(new Filter({
					path: "CIClassifiedBy",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: cby.toUpperCase()
				}));
			}
			var uo = this.byId("fbsfUploadedOn");
			if (uo.getFrom()) {
				aFilters.push(new Filter({
					path: "UploadedOn",
					operator: sap.ui.model.FilterOperator.BT,
					value1: uo.getFrom(),
					value2: uo.getTo()
				}));
			}
			var dr = this.byId("fbsfClassOn");
			if (dr.getFrom()) {
				aFilters.push(new Filter({
					path: "ClassifiedOn",
					operator: sap.ui.model.FilterOperator.BT,
					value1: dr.getFrom(),
					value2: dr.getTo()
				}));
			}
			var St = this.byId("fbsfStatus").getSelectedKey();
			var btnAssign = this.byId("btnAssign");
			if (St.length > 0) {
				aFilters.push(new Filter({
					path: "ClassStatus",
					operator: sap.ui.model.FilterOperator.EQ,
					value1: St
				}));
				if (St !== "0") {
					btnAssign.setEnabled(false);
					if (userRole < 3) {
						this.byId("tabMain").setMode("None");
					}
				} else {
					if (userRole < 3) {
						this.byId("tabMain").setMode("MultiSelect");
					}
					btnAssign.setEnabled(true);
				}
			}
			return aFilters;
		},
		_getFiltersDownload: function () {
			var aFilters = [];
			var pid = this.byId("fbsfProdId").getValue().trim();
			if (pid.length > 0) {
				aFilters.push(new Filter({
					path: "CIProduct",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: pid.toUpperCase()
				}));
			}
			var pdesc = this.byId("fbsfProdDesc").getValue().trim();
			if (pdesc.length > 0) {
				pdesc = formatter.noSpecialChar(pdesc);
				aFilters.push(new Filter({
					path: "CIDescription",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: pdesc.toUpperCase()
				}));
			}
			var sch = this.byId("fbcbScheme");
			if (sch.getSelectedKey() !== "") {
				aFilters.push(new Filter({
					path: "Scheme",
					operator: sap.ui.model.FilterOperator.EQ,
					value1: sch.getSelectedKey()
				}));
			}
			var cod = this.byId("fbsfNsCode").getValue().trim();
			if (cod.length > 0) {
				aFilters.push(new Filter({
					path: "Code",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: cod
				}));
			}
			var cby = this.byId("fbsfClassBy").getValue().trim();
			if (cby.length > 0) {
				aFilters.push(new Filter({
					path: "CIClassifiedBy",
					operator: sap.ui.model.FilterOperator.Contains,
					value1: cby.toUpperCase()
				}));
			}
			var dr = this.byId("fbsfClassOn");
			if (dr.getFrom()) {
				aFilters.push(new Filter({
					path: "ClassifiedOn",
					operator: sap.ui.model.FilterOperator.BT,
					value1: dr.getFrom(),
					value2: dr.getTo()
				}));
			}
			var uo = this.byId("fbsfUploadedOn");
			if (uo.getFrom()) {
				aFilters.push(new Filter({
					path: "UploadedOn",
					operator: sap.ui.model.FilterOperator.BT,
					value1: uo.getFrom(),
					value2: uo.getTo()
				}));
			}
			var St = this.byId("fbsfStatus").getSelectedKey();

			if (St.length > 0) {
				aFilters.push(new Filter({
					path: "ClassStatus",
					operator: sap.ui.model.FilterOperator.EQ,
					value1: St
				}));
			}
			return aFilters;
		},
		/**
		 *@memberOf be.deloitte.dce.dceclassified.controller.Worklist
		 */
		action: function (oEvent) {
			var that = this;
			var actionParameters = JSON.parse(oEvent.getSource().data("wiring").replace(/'/g, "\""));
			var eventType = oEvent.getId();
			var aTargets = actionParameters[eventType].targets || [];
			aTargets.forEach(function (oTarget) {
				var oControl = that.byId(oTarget.id);
				if (oControl) {
					var oParams = {};
					for (var prop in oTarget.parameters) {
						oParams[prop] = oEvent.getParameter(oTarget.parameters[prop]);
					}
					oControl[oTarget.action](oParams);
				}
			});
			var oNavigation = actionParameters[eventType].navigation;
			if (oNavigation) {
				var oParams = {};
				(oNavigation.keys || []).forEach(function (prop) {
					oParams[prop.name] = encodeURIComponent(JSON.stringify({
						value: oEvent.getSource().getBindingContext(oNavigation.model).getProperty(prop.name),
						type: prop.type
					}));
				});
				if (Object.getOwnPropertyNames(oParams).length !== 0) {
					this.getOwnerComponent().getRouter().navTo(oNavigation.routeName, oParams);
				} else {
					this.getOwnerComponent().getRouter().navTo(oNavigation.routeName);
				}
			}
		}
	});
});