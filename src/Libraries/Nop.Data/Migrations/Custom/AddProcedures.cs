using System;
using FluentMigrator;

namespace Nop.Data.Migrations.Custom
{
    [NopMigration("2023/02/28 19:32:08:9036874", "Adding procedures.")]
    [SkipMigrationOnInstall]
    public class AddProcedures : Migration
    {
        private readonly IMigrationManager _migrationManager;

        public AddProcedures(IMigrationManager migrationManager)
        {
            _migrationManager = migrationManager;
        }

        public override void Down()
        {
            //Drop procedures
            Execute.Sql("DROP PROCEDURE AddProduct;");
            Execute.Sql("DROP PROCEDURE AddPicture;");
            Execute.Sql("DROP PROCEDURE UpdateProduct;");
            Execute.Sql("DROP PROCEDURE DeletePictures;");
        }

        public override void Up()
        {
            //Scripts for creating procedures insert product and pictures
            Execute.Script("../../Libraries/Nop.Data/Migrations/Custom/Scripts/AddProductProcedure.sql");
            Execute.Script("../../Libraries/Nop.Data/Migrations/Custom/Scripts/AddPictureProcedure.sql");

            //Script for updating product
            Execute.Script("../../Libraries/Nop.Data/Migrations/Custom/Scripts/UpdateProductProcedure.sql");

            //Script for deleting pictures of the product
            Execute.Script("../../Libraries/Nop.Data/Migrations/Custom/Scripts/DeletePicturesProcedure.sql");
        }
    }
}
