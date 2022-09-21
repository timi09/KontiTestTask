using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using KontiEmployees.Models;
using Microsoft.Data.SqlClient;
using System.Diagnostics.Metrics;
using System.IO;

namespace KontiEmployees.Data
{
    public class KontiEmployeesContext : DbContext
    {
        public KontiEmployeesContext (DbContextOptions<KontiEmployeesContext> options)
            : base(options)
        {
        }

        public void CreateEmployee(Employee employee) 
        {
            this.Database.ExecuteSqlRaw("CreateEmployee @FullName, @PhoneNumber, @Email, @EmployeeType, @Country, @City, @Street, @HouseNum, @ApartmentNum", GetEmployeSqlParams(employee).ToArray());
        }

        public List<Employee> GetAllEmployees() 
        {
            return ReadEmployees("ReadEmployeesAll");
        }

        public List<Employee> GetEmployeesByType(string type)
        {
            var EmployeeType = new SqlParameter("EmployeeType", type);

            return ReadEmployees("ReadEmployeesByType @EmployeeType", EmployeeType);
        }

        public Employee GetEmployeeById(int? id)
        {
            var Id = new SqlParameter("Id", id);

            return ReadEmployees("ReadEmployeeById @Id", Id).First();
        }

        public void DeleteEmployeeById(int? id) 
        {
            var Id = new SqlParameter("Id", id);

            this.Database.ExecuteSqlRaw("DeleteEmployee @Id", Id);
        }

        public void UpdateEmployeeById(int? id, Employee employee)
        {
            var sqlParams = GetEmployeSqlParams(employee);

            var Id = new SqlParameter("Id", id);

            sqlParams.Add(Id);

            this.Database.ExecuteSqlRaw("UpdateEmployee @Id, @FullName, @PhoneNumber, @Email, @EmployeeType, @Country, @City, @Street, @HouseNum, @ApartmentNum", sqlParams.ToArray());
        }

        public List<EmployeeType> GetAllEmployeeTypes()
        {
            return ReadEmployeeTypes("ReadEmployeeTypesAll");
        }

        private List<Employee> ReadEmployees(string commandString, params SqlParameter[] parameters) 
        {
            List<Employee> employees = new List<Employee>();
            using (var command = this.Database.GetDbConnection().CreateCommand())
            {
                command.Parameters.AddRange(parameters);
                command.CommandText = commandString;

                this.Database.OpenConnection();
                using (var reader = command.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            Employee employee = new Employee();

                            employee.Id = Convert.ToInt32(reader.GetValue(0));
                            employee.FullName = reader.GetValue(1).ToString();

                            employee.PhoneNumber = reader.GetValue(2).ToString();
                            employee.Email = reader.GetValue(3).ToString();

                            employee.Type.Id = Convert.ToInt32(reader.GetValue(4));
                            employee.Type.Title = reader.GetValue(5).ToString();

                            employee.Adress.Id = Convert.ToInt32(reader.GetValue(6));
                            employee.Adress.Country = reader.GetValue(7).ToString();
                            employee.Adress.City = reader.GetValue(8).ToString();
                            employee.Adress.Street = reader.GetValue(9).ToString();
                            employee.Adress.HouseNum = reader.GetValue(10).ToString();
                            employee.Adress.ApartmentNum = reader.GetValue(11).ToString();

                            employees.Add(employee);
                        }
                    }
                }
            }
            return employees;
        }

        private List<EmployeeType> ReadEmployeeTypes(string commandString, params SqlParameter[] parameters)
        {
            List<EmployeeType> types = new List<EmployeeType>();
            using (var command = this.Database.GetDbConnection().CreateCommand())
            {
                command.Parameters.AddRange(parameters);
                command.CommandText = commandString;

                this.Database.OpenConnection();
                using (var reader = command.ExecuteReader())
                {
                    if (reader.HasRows)
                    {
                        while (reader.Read())
                        {
                            EmployeeType type = new EmployeeType();

                            type.Id = Convert.ToInt32(reader.GetValue(0));
                            type.Title = reader.GetValue(1).ToString();

                            types.Add(type);
                        }
                    }
                }
            }
            return types;
        }

        private static List<SqlParameter> GetEmployeSqlParams(Employee employee) 
        {
            var FullName = new SqlParameter("FullName", employee.FullName);
            var PhoneNumber = new SqlParameter("PhoneNumber", employee.PhoneNumber);
            var Email = new SqlParameter("Email", employee.Email);
            var EmployeeType = new SqlParameter("EmployeeType", employee.Type.Title);
            var Country = new SqlParameter("Country", employee.Adress.Country);
            var City = new SqlParameter("City", employee.Adress.City);
            var Street = new SqlParameter("Street", employee.Adress.Street);
            var HouseNum = new SqlParameter("HouseNum", employee.Adress.HouseNum);
            var ApartmentNum = new SqlParameter("ApartmentNum", employee.Adress.ApartmentNum);

            return new List<SqlParameter>() { FullName, PhoneNumber, Email, EmployeeType, Country, City, Street, HouseNum, ApartmentNum };
        }
    }


}
