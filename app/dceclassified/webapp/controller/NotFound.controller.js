sap.ui.define([
		"be/deloitte/dce/dceclassified/controller/BaseController"
	], function (BaseController) {
		"use strict";

		return BaseController.extend("be.deloitte.dce.dceclassified.controller.NotFound", {

			/**
			 * Navigates to the worklist when the link is pressed
			 * @public
			 */
			onLinkPressed : function () {
				this.getRouter().navTo("worklist");
			}

		});

	}
);