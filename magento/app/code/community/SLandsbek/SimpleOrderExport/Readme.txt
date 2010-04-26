Simple Order Export Magento Extension Readme

This magento extension makes it possible to export orders to csv files. You can select the orders you want to export in the sales orders grid and start the export process by simply selecting "Export to .csv file" from the actions dropdown. After exporting you can directly download the csv file to your computer. The csv files also get saved in the folder "var/export" in your magento installation.

Changelog 1.0.2 - 1.0.3:

- Added phone number of shipping address to export
- Added phone number of billing address to export

Changelog 1.0.1 - 1.0.2:

- Bugfix: Ignore shipping address if order is virtual
- Added item increment number to export
- Added full name of shipping address country to export
- Added full name of billing address country to export
- Added code of shipping address state to export
- Added full name of shipping address state to export
- Added code of billing address state to export
- Added full name of billing address state to export
- Added total qty of ordered items to export
- Added customer name to export
- Added customer email to export
- Added item qty invoiced to export
- Added item qty shipped to export
- Added item qty canceled to export
- Added item qty refunded to export
- Renamed column "Item Ordered Qty" to "Item Qty Ordered"