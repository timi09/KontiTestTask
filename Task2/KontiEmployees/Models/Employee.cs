using System.ComponentModel.DataAnnotations;

namespace KontiEmployees.Models
{
    public class Employee
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "��� �����������")]
        [RegularExpression(@"^[�-ߨ][�-��]{2,}([-][�-ߨ][�-��]{2,})?\s[�-ߨ][�-��]{2,}\s[�-ߨ][�-��]{2,}$", ErrorMessage = "������������ ������ ���. ������� ��� � ��������� �������: ������� ��� ��������")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "����� �������� ����������")]
        [RegularExpression(@"^([+]?[0-9\s-\(\)]{3,25})*$", ErrorMessage = "������������ ������ ������ ��������")]
        public string PhoneNumber { get; set; }

        [Required(ErrorMessage = "Email ����������")]
        [EmailAddress(ErrorMessage = "���������� ������� �������������� Email")]
        public string Email { get; set; }

        public Adress Adress { get; set; } = new Adress();

        public EmployeeType Type { get; set; } = new EmployeeType();
    }
}
