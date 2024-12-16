import UIKit

class QuizViewController: UIViewController {
    
    private var questions: [(question: String, answers: [String], correctIndex: Int)] = [
        ("What is the capital of France?", ["Paris", "Berlin", "Rome", "Madrid"], 0),
        ("Which planet is known as the Red Planet?", ["Earth", "Mars", "Jupiter", "Venus"], 1),
        ("What is the smallest prime number?", ["0", "1", "2", "3"], 2),
        ("Which ocean is the largest?", ["Atlantic", "Indian", "Arctic", "Pacific"], 3),
        ("What is the tallest mountain in the world?", ["K2", "Mount Everest", "Mount Kilimanjaro", "Mont Blanc"], 1),
        ("Which element has the chemical symbol 'O'?", ["Oxygen", "Gold", "Osmium", "Ozone"], 0),
        ("Who wrote 'Hamlet'?", ["Shakespeare", "Dickens", "Hemingway", "Austen"], 0),
        ("What is the speed of light?", ["300,000 km/s", "150,000 km/s", "500,000 km/s", "700,000 km/s"], 0),
        ("Which country is known as the Land of the Rising Sun?", ["China", "South Korea", "Japan", "India"], 2),
        ("Who painted the Mona Lisa?", ["Picasso", "Da Vinci", "Van Gogh", "Dali"], 1)
    ]

    
    private var currentQuestionIndex = 0
    private var correctAnswersCount = 0
    
    private let questionLabel = UILabel()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Question Label
        questionLabel.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        questionLabel.textColor = .white
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        view.addSubview(questionLabel)
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Stack View for Answers
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40)
        ])
    }
    
    private func loadQuestion() {
        // Clear existing buttons
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Get current question
        let currentQuestion = questions[currentQuestionIndex]
        questionLabel.text = currentQuestion.question
        
        // Create answer buttons with increased width and height
        for (index, answer) in currentQuestion.answers.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(answer, for: .normal)
            button.setTitleColor(.black, for: .normal)  // Text color set to black
            button.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .medium)
            button.backgroundColor = .yellow  // Set the background color to yellow
            button.layer.cornerRadius = 15
            button.tag = index
            button.addTarget(self, action: #selector(answerTapped(_:)), for: .primaryActionTriggered)
            
            // Set a fixed width and height for each button
            button.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(button)
            
            // Add width and height constraints
            NSLayoutConstraint.activate([
                button.widthAnchor.constraint(equalToConstant: 40), // Set the width to 600 points
                button.heightAnchor.constraint(equalToConstant: 120) // Set the height to 70 points
            ])
        }
    }
    
    @objc private func answerTapped(_ sender: UIButton) {
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = sender.tag == currentQuestion.correctIndex
        
        if isCorrect {
            correctAnswersCount += 1
        }
        
        showResultAlert(isCorrect: isCorrect)
    }
    
    private func showResultAlert(isCorrect: Bool) {
        let alert = UIAlertController(
            title: isCorrect ? "Correct!" : "Wrong!",
            message: isCorrect
                ? "Good job! You selected the correct answer."
                : "Oops! The correct answer was \(questions[currentQuestionIndex].answers[questions[currentQuestionIndex].correctIndex]).",
            preferredStyle: .alert
        )
        
        let nextAction = UIAlertAction(title: "Next", style: .default) { [weak self] _ in
            self?.handleNextQuestion()
        }
        alert.addAction(nextAction)
        present(alert, animated: true)
    }
    
    private func handleNextQuestion() {
        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
            loadQuestion()
        } else {
            navigateToEndingScreen()
        }
    }
    
    private func navigateToEndingScreen() {
        let endingVC = EndingViewController()
        endingVC.score = correctAnswersCount
        endingVC.totalQuestions = questions.count
        navigationController?.pushViewController(endingVC, animated: true)
    }
    
    func resetQuiz() {
        currentQuestionIndex = 0
        correctAnswersCount = 0
        loadQuestion()
    }
}
