// 🧼 Cleaned-up BeeTask Tutorial System (minimal, without completion tracking)

class TutorialController {
  constructor() {
    this.currentStep = 1
    this.totalSteps = 5
    this.isTransitioning = false
    this.completionCallbacks = []
    this.reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches

    this.init()
  }

  init() {
    this.bindEvents()
    this.updateProgress()
    this.updateNavigation()
    this.updateStepDots()
  }

  bindEvents() {
    document.getElementById("nextBtn")?.addEventListener("click", () => this.nextStep())
    document.getElementById("prevBtn")?.addEventListener("click", () => this.previousStep())
    document.getElementById("completeBtn")?.addEventListener("click", () => this.completeTutorial())
    document.getElementById("skipBtn")?.addEventListener("click", () => this.skipTutorial())

    document.querySelectorAll(".dot").forEach((dot, index) => {
      dot.addEventListener("click", () => this.goToStep(index + 1))
    })
  }

  nextStep() {
    if (this.currentStep < this.totalSteps) {
      this.goToStep(this.currentStep + 1)
    } else {
      this.showCompletion()
    }
  }

  previousStep() {
    if (this.currentStep > 1) {
      this.goToStep(this.currentStep - 1)
    }
  }

  goToStep(stepNumber) {
    if (stepNumber < 1 || stepNumber > this.totalSteps || stepNumber === this.currentStep) return

    document.getElementById(`step-${this.currentStep}`)?.classList.remove("active")
    document.getElementById(`step-${stepNumber}`)?.classList.add("active")
    this.currentStep = stepNumber
    this.updateProgress()
    this.updateNavigation()
    this.updateStepDots()
  }

  showCompletion() {
    document.getElementById(`step-${this.currentStep}`)?.classList.remove("active")
    document.getElementById("step-complete")?.classList.add("active")
    this.currentStep = "complete"
    this.updateNavigation()
    this.playSuccessSound()
  }

  completeTutorial() {
    this.completionCallbacks.forEach((cb) => cb())
    this.closeTutorial()
  }

  skipTutorial() {
    if (confirm("Skip tutorial?")) this.closeTutorial()
  }

  closeTutorial() {
    const el = document.getElementById("tutorialApp")
    if (el) el.style.display = "none"
    document.body.style.overflow = ""
  }

  updateProgress() {
    const fill = document.getElementById("progressFill")
    if (typeof this.currentStep === "number" && fill) {
      fill.style.width = `${(this.currentStep / this.totalSteps) * 100}%`
    }
    document.getElementById("currentStep").textContent = this.currentStep
  }

  updateNavigation() {
    const isComplete = this.currentStep === "complete"
    document.getElementById("nextBtn").style.display = isComplete ? "none" : "flex"
    document.getElementById("completeBtn").style.display = isComplete ? "flex" : "none"
  }

  updateStepDots() {
    document.querySelectorAll(".dot").forEach((dot, index) => {
      dot.classList.toggle("active", index + 1 === this.currentStep)
    })
  }

  onComplete(cb) {
    if (typeof cb === "function") this.completionCallbacks.push(cb)
  }

  playSuccessSound() {
    if (this.reducedMotion) return
    try {
      const ctx = new (window.AudioContext || window.webkitAudioContext)()
      const notes = [523.25, 659.25, 783.99, 1046.5] // C5 E5 G5 C6
      notes.forEach((freq, i) => {
        const osc = ctx.createOscillator()
        const gain = ctx.createGain()
        osc.type = "sine"
        osc.frequency.setValueAtTime(freq, ctx.currentTime + i * 0.15)
        gain.gain.setValueAtTime(0.1, ctx.currentTime + i * 0.15)
        gain.gain.exponentialRampToValueAtTime(0.01, ctx.currentTime + i * 0.3)
        osc.connect(gain)
        gain.connect(ctx.destination)
        osc.start(ctx.currentTime + i * 0.15)
        osc.stop(ctx.currentTime + i * 0.3)
      })
    } catch (e) {
      console.warn("Audio not supported:", e)
    }
  }
}

// Force-start tutorial on DOM load
window.addEventListener("DOMContentLoaded", () => {
  const app = document.getElementById("tutorialApp")
  if (app) {
    app.style.display = "flex"
    document.body.style.overflow = "hidden"
    window.tutorialController = new TutorialController()
  }
})


// Force-start tutorial on DOM load
window.addEventListener("DOMContentLoaded", () => {
  const app = document.getElementById("tutorialApp")
  if (app) {
    app.style.display = "flex"
    document.body.style.overflow = "hidden"
    window.tutorialController = new TutorialController()
  }
})


// Initialize tutorial when DOM is ready
document.addEventListener("DOMContentLoaded", () => {
  try {
    // Performance mark
    performance.mark("tutorial-dom-ready");

    const tutorialApp = document.getElementById("tutorialApp");

    // ✅ Luôn khởi tạo tutorial, không kiểm tra completed
    if (tutorialApp) {
      tutorialApp.style.display = "flex";
      tutorialApp.style.opacity = "1";
      document.body.style.overflow = "hidden";
      document.body.classList.add("no-scroll");

      window.tutorialController = new TutorialController();

      // Set completion callback
      window.tutorialController.onComplete((data) => {
        console.log("Tutorial completed with data:", data);
      });
    }
  } catch (error) {
    console.error("Error initializing tutorial:", error);

    // Fallback: redirect to home if tutorial fails
    setTimeout(() => {
      window.location.href = "Home.jsp";
    }, 2000);
  }
});


// Export for external use
window.TutorialController = TutorialController

// Global utility functions with enhanced features
window.BeeTaskTutorial = {
  show: () => {
    try {
      const tutorialApp = document.getElementById("tutorialApp")
      if (tutorialApp) {
        tutorialApp.style.display = "flex"
        tutorialApp.style.opacity = "1"
        document.body.style.overflow = "hidden"
        document.body.classList.add("no-scroll")

        if (!window.tutorialController) {
          window.tutorialController = new TutorialController()
        } else {
          window.tutorialController.reset()
        }

        console.log("Tutorial shown manually")
      }
    } catch (error) {
      console.error("Error showing tutorial:", error)
    }
  },

  hide: () => {
    try {
      if (window.tutorialController) {
        window.tutorialController.closeTutorial()
      }
    } catch (error) {
      console.error("Error hiding tutorial:", error)
    }
  },

  reset: () => {
    try {
      localStorage.removeItem("beetask_tutorial_completion")
      if (window.tutorialController) {
        window.tutorialController.reset()
      }
      console.log("Tutorial reset")
    } catch (error) {
      console.error("Error resetting tutorial:", error)
    }
  },

  isCompleted: () => TutorialController.isCompleted(),

  getProgress: () => {
    try {
      return window.tutorialController
        ? {
            currentStep: window.tutorialController.currentStep,
            totalSteps: window.tutorialController.totalSteps,
            isCompleted: TutorialController.isCompleted(),
            sessionDuration: window.tutorialController.getSessionDuration(),
            performanceMetrics: window.tutorialController.getPerformanceMetrics(),
          }
        : null
    } catch (error) {
      console.error("Error getting progress:", error)
      return null
    }
  },

  getCompletionData: () => TutorialController.getCompletionData(),

  skipToStep: (stepNumber) => {
    try {
      if (window.tutorialController && stepNumber >= 1 && stepNumber <= 5) {
        window.tutorialController.goToStep(stepNumber)
      }
    } catch (error) {
      console.error("Error skipping to step:", error)
    }
  },
}

