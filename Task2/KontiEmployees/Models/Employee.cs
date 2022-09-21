using System.ComponentModel.DataAnnotations;

namespace KontiEmployees.Models
{
    public class Employee
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "ФИО обязательно")]
        [RegularExpression(@"^[А-ЯЁ][а-яё]{2,}([-][А-ЯЁ][а-яё]{2,})?\s[А-ЯЁ][а-яё]{2,}\s[А-ЯЁ][а-яё]{2,}$", ErrorMessage = "Неправильный формат ФИО. Введите ФИО в следующем формате: Фамилия Имя Отчество")]
        public string FullName { get; set; }

        [Required(ErrorMessage = "Номер телефона обязателен")]
        [RegularExpression(@"^([+]?[0-9\s-\(\)]{3,25})*$", ErrorMessage = "Неправильный формат номера телефона")]
        public string PhoneNumber { get; set; }

        [Required(ErrorMessage = "Email обязателен")]
        [EmailAddress(ErrorMessage = "Пожалуйста введите действительный Email")]
        public string Email { get; set; }

        public Adress Adress { get; set; } = new Adress();

        public EmployeeType Type { get; set; } = new EmployeeType();
    }
}
