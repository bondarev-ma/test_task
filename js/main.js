const departments = [
    {id: 1, name: 'Цех 1', city: 1},
    {id: 2, name: 'Цех 2', city: 1},
    {id: 3, name: 'Цех 3', city: 1},
    {id: 4, name: 'Цех 4', city: 2},
    {id: 5, name: 'Цех 5', city: 2},
    {id: 6, name: 'Цех 6', city: 2},
    {id: 7, name: 'Цех 7', city: 2},
];

const employees = [
    {id: 1, name: 'Василий', department: 1},
    {id: 2, name: 'Елена', department: 1},
    {id: 3, name: 'Михаил', department: 4},
    {id: 4, name: 'Евгений', department: 5},
    {id: 5, name: 'Светлана', department: 5},
    {id: 6, name: 'Кирилл', department: 2},
    {id: 7, name: 'Ольга', department: 3},
    {id: 8, name: 'Наталья', department: 3},
    {id: 9, name: 'Олег', department: 6},
    {id: 10, name: 'Иван', department: 6},
    {id: 11, name: 'Анна', department: 7},
];

function submitData() {
    event.preventDefault();

    const form = {
        city: document.getElementById('city').value,
        department: document.getElementById('department').value,
        employee: document.getElementById('employee').value,
        team: document.getElementById('team').value,
        shift: document.getElementById('shift').value
    };

    document.cookie = 'form=' + JSON.stringify(form);
}

function fillDepartments() {
    const city = document.getElementById('city');

    // фильтрует цеха по выбранному городу
    // если город не выбран, выводятся все цеха
    const optionParameters = city.value ? departments.filter(el => el.city == city.value) : departments;
    const options = [new Option('', undefined, true)].concat(optionParameters.map(el => new Option(el.name, el.id)));

    setOptions(document.getElementById('department'), options);
}

function fillEmployees() {
    const department = document.getElementById('department');
    const city = document.getElementById('city');
    
    // фильтрует работников по выбранному цеху
    // если цех не выбран, берёт работников из выбранного города
    // если не выбран и город, выводятся все работники
    const optionParameters = department.value ? employees.filter(el => el.department == department.value) : city.value ? employees.filter(el => departments.filter(el => el.city == city.value).map(el => el.id).includes(el.department)) : employees;
    const options = [new Option('', undefined, true)].concat(optionParameters.map(el => new Option(el.name, el.id)));

    setOptions(document.getElementById('employee'), options);
}

function setOptions(select, options) {
    select.options.length = 0;

    options.forEach(el => {
        select.add(el);
    });
}

window.addEventListener("load", (event) => {
    fillDepartments();
    fillEmployees();
});