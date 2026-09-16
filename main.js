const API_URL = "https://localhost:7054/api";


// ===============================
// Task 4
// Load Students
// ===============================

async function loadStudents() {

    try {

        const response =
            await fetch(`${API_URL}/students`);

        if (!response.ok) {
            throw new Error("Failed to load students");
        }

        const students =
            await response.json();

        console.log(students);

        displayStudents(students);

    }
    catch (error) {

        document.getElementById("studentMessage")
            .innerText = "Error loading students";

        console.error(error);
    }
}


// ===============================
// Task 5
// Display Students
// ===============================

function displayStudents(students) {

    const tableBody =
        document.getElementById("studentsTableBody");

    tableBody.innerHTML = "";


    if (students.length === 0) {

        document.getElementById("studentMessage")
            .innerText = "No students found.";

        return;
    }


    document.getElementById("studentMessage")
        .innerText = "";


    students.forEach(student => {

        const row = `
            <tr>

                <td>${student.id}</td>

                <td>${student.name}</td>

                <td>${student.age}</td>

                <td>${student.department}</td>

            </tr>
        `;

        tableBody.innerHTML += row;

    });
}


// ===============================
// Task 6
// Load Departments
// ===============================

async function loadDepartments() {

    try {

        const response =
            await fetch(`${API_URL}/departments`);

        if (!response.ok) {
            throw new Error("Failed to load departments");
        }

        const departments =
            await response.json();

        const list =
            document.getElementById("departmentsList");

        const select =
            document.getElementById("departmentSelect");

        list.innerHTML = "";

        select.innerHTML = `
            <option value="">
                Select Department
            </option>
        `;

        departments.forEach(department => {

            list.innerHTML += `
                <div class="alert alert-info">
                    ${department.name}
                </div>
            `;

            select.innerHTML += `
                <option value="${department.id}">
                    ${department.name}
                </option>
            `;

        });

    }
    catch (error) {

        console.error(error);

    }
}

// ===============================
// Task 7
// Search Students
// ===============================

async function searchStudents() {

    const text =
        document.getElementById("searchInput").value;

    try {

        const response =
            await fetch(
                `${API_URL}/students/search?text=${text}`
            );

        const students =
            await response.json();

        displayStudents(students);

    }
    catch (error) {

        console.error(error);

    }
}


// ===============================
// When Page Opens
// ===============================

loadStudents();

loadDepartments();
// Add Department

document.getElementById("departmentForm")
    .addEventListener("submit", async function (event) {

        event.preventDefault();

        const name =
            document.getElementById("departmentName").value.trim();

        const message =
            document.getElementById("departmentMessage");

        if (name === "") {
            message.innerText = "Department name is required.";
            return;
        }

        try {

            const response = await fetch(
                `${API_URL}/departments`,
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({
                        name: name
                    })
                }
            );

            if (!response.ok) {
                const error = await response.text();
                message.innerText = error;
                return;
            }

            message.innerText = "Department added successfully.";

            document.getElementById("departmentName").value = "";

            loadDepartments();

        }
        catch (error) {

            message.innerText = "Cannot connect to server.";

            console.error(error);
        }

    });

    // Add Student

document.getElementById("studentForm")
    .addEventListener("submit", async function (event) {

        event.preventDefault();

        const name =
            document.getElementById("studentName").value.trim();

        const age =
            document.getElementById("studentAge").value;

        const departmentId =
            document.getElementById("departmentSelect").value;

        const message =
            document.getElementById("studentFormMessage");


        if (name === "") {

            message.innerText = "Student name is required.";
            return;

        }


        if (age === "") {

            message.innerText = "Age is required.";
            return;

        }


        if (age < 18 || age > 60) {

            message.innerText =
                "Age must be between 18 and 60.";

            return;

        }


        if (departmentId === "") {

            message.innerText =
                "Please select a department.";

            return;

        }


        try {

            const response = await fetch(
                `${API_URL}/students`,
                {
                    method: "POST",

                    headers: {
                        "Content-Type": "application/json"
                    },

                    body: JSON.stringify({
                        name: name,
                        age: Number(age),
                        departmentId: Number(departmentId)
                    })
                }
            );


            if (!response.ok) {

                const error =
                    await response.text();

                message.innerText = error;

                return;

            }


            message.innerText =
                "Student added successfully.";
setTimeout(function () {
    message.innerText = "";
}, 3000);

            document.getElementById("studentForm").reset();

            loadStudents();

        }
        catch (error) {

            message.innerText =
                "Cannot connect to server.";

            console.error(error);

        }

    });