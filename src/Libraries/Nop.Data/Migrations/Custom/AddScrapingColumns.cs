using FluentMigrator;
using Nop.Core.Domain.Catalog;
using Nop.Data.Mapping;


namespace Nop.Data.Migrations.Custom
{
    [NopMigration("2023/02/22 11:26:08:9036874", "Adding Scraping Columns")]
        [SkipMigrationOnInstall]
        public class AddScrapingColumns : Migration
    {
            #region Fields

            private readonly IMigrationManager _migrationManager;

            #endregion

            #region Ctor

            public AddScrapingColumns(IMigrationManager migrationManager)
            {
                _migrationManager = migrationManager;
            }

        #endregion

        #region Methods
        public override void Up()
        {
            var productTableName = NameCompatibilityManager.GetTableName(typeof(Product));
            var isScrapedProductColumnName = "IsScrapedProduct";
            if (!Schema.Table(productTableName).Column(isScrapedProductColumnName).Exists())
            {
                Alter.Table(productTableName).AddColumn(isScrapedProductColumnName).AsBoolean().NotNullable().SetExistingRowsTo(0);
            }
            var nameChangedColumnName = "NameChanged";
            if (!Schema.Table(productTableName).Column(nameChangedColumnName).Exists())
            {
                Alter.Table(productTableName).AddColumn(nameChangedColumnName).AsBoolean().NotNullable().SetExistingRowsTo(0);
            }

            var pictureTableName = "Picture";
            var webPictureColumnName = "WebPicture";
            if (!Schema.Table(pictureTableName).Column(webPictureColumnName).Exists())
            {
                Alter.Table(pictureTableName).AddColumn(webPictureColumnName).AsString(int.MaxValue).Nullable();
            }
        }
        public override void Down()
        {
            var productTableName = NameCompatibilityManager.GetTableName(typeof(Product));
            var isScrapedProductColumnName = "IsScrapedProduct";
            if (Schema.Table(productTableName).Column(isScrapedProductColumnName).Exists())
            {
                Delete.Column(isScrapedProductColumnName).FromTable(productTableName);
            }
            var nameChangedColumnName = "NameChanged";
            if (Schema.Table(productTableName).Column(nameChangedColumnName).Exists())
            {
                Delete.Column(nameChangedColumnName).FromTable(productTableName);
            }

            var pictureTableName = "Picture";
            var webPictureColumnName = "WebPicture";
            if (Schema.Table(pictureTableName).Column(webPictureColumnName).Exists())
            {
                Delete.Column(webPictureColumnName).FromTable(pictureTableName);
            }
        }

        #endregion
    }

}
